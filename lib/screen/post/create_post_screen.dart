import 'package:flutter/foundation.dart' show kIsWeb;
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controller/post_controller.dart';
import '../../model/post_model.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({super.key});

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final PostController controller = Get.find<PostController>();
  final ImagePicker _picker = ImagePicker();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final RxBool _isPublished = true.obs;
  final _imagePath = RxString('');
  final Rx<Uint8List?> _imageBytes = Rx<Uint8List?>(null);
  final RxBool _isUploading = false.obs;

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      if (kIsWeb) {
        final bytes = await image.readAsBytes();
        _imageBytes.value = bytes;
        _imagePath.value = image.path;
        print('🌐 Web Image selected');
      } else {
        _imagePath.value = image.path;
        print('📱 Mobile Image selected: ${image.path}');
      }
    }
  }

  Future<void> _takePhoto() async {
    if (kIsWeb) {
      Get.snackbar('Notice', 'Camera is not supported on Web',
          backgroundColor: Colors.orange);
      return;
    }

    final XFile? image = await _picker.pickImage(
      source: ImageSource.camera,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image != null) {
      _imagePath.value = image.path;
      print('📷 Photo taken: ${image.path}');
    }
  }

  Future<void> _createPost() async {
    if (_titleController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a title',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    _isUploading.value = true;

    try {
      final newPost = PostModel(
        title: _titleController.text,
        description: _descController.text,
        status: _isPublished.value ? 'published' : 'draft',
        date: DateTime.now().toString(),
      );

      //  Post
      final createdPost = await controller.createPostDirect(newPost);
      print(' Post created with ID: ${createdPost.id}');

      //  Upload
      if (_imagePath.value.isNotEmpty && createdPost.id != null) {

        final dynamic imageSource = kIsWeb ? _imageBytes.value : File(_imagePath.value);

        if (imageSource != null) {
          await controller.uploadImage(createdPost.id!, imageSource);
          print('Image uploaded successfully');
        }
      }

      //ទាញយកទិន្នន័យថ្មីភ្លាមៗ ដើម្បីឱ្យ List អាប់ដេតដោយស្វ័យប្រវត្តិ
      await controller.fetchPosts();

      Get.snackbar('Success', 'Post created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      Get.snackbar('Error', 'Failed to create post: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      _isUploading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('អត្ថបទ',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() => GestureDetector(
              onTap: () => _showImageSourceDialog(),
              child: Container(
                width: double.infinity,
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.teal.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.teal.shade200),
                ),
                child: _imagePath.value.isNotEmpty
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: kIsWeb && _imageBytes.value != null
                      ? Image.memory(
                    _imageBytes.value!,
                    fit: BoxFit.cover,
                  )
                      : Image.file(
                    File(_imagePath.value),
                    fit: BoxFit.cover,
                  ),
                )
                    : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined,
                        size: 50, color: Colors.teal),
                    const SizedBox(height: 8),
                    Text(
                      'ចុចដើម្បីជ្រើសរើសរូបភាព',
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            )),

            const SizedBox(height: 24),

            const Text('ចំណងជើង',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'អត្ថបទជំបូងរបស់ខ្ញុំ',
                prefixIcon: const Icon(Icons.title, color: Colors.teal),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 16),

            const Text('មាតិកា',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'សរសេរអ្វីមួយ...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('បានផ្សាយ',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                    Text('មើលឃើញដោយអ្នកកាន់អស់គ្នា',
                        style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  ],
                ),
                Obx(() => Switch(
                  value: _isPublished.value,
                  onChanged: (value) => _isPublished.value = value,
                  activeThumbColor: Colors.teal,
                )),
              ],
            ),

            const SizedBox(height: 32),

            Obx(() => SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isUploading.value ? null : _createPost,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isUploading.value
                    ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text('កំពុងបង្កើត...',
                        style: TextStyle(color: Colors.white)),
                  ],
                )
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, color: Colors.white),
                    SizedBox(width: 8),
                    Text('បង្កើតអត្ថបទ',
                        style: TextStyle(
                            color: Colors.white, fontSize: 16)),
                  ],
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library, color: Colors.teal),
              title: const Text('ជ្រើសរើសពី Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            if (!kIsWeb)
              ListTile(
                leading: const Icon(Icons.camera_alt, color: Colors.teal),
                title: const Text('ថតរូបពី Camera'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
            if (_imagePath.value.isNotEmpty)
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('លុបរូបភាព',
                    style: TextStyle(color: Colors.red)),
                onTap: () {
                  _imagePath.value = '';
                  _imageBytes.value = null;
                  Navigator.pop(context);
                },
              ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _imagePath.close();
    _imageBytes.close();
    super.dispose();
  }
}