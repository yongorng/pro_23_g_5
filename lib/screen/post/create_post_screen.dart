import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../controller/post_controller.dart';
import '../../model/post_model.dart';
import '../../theme/app_color.dart';

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
  final RxString _imagePath = RxString('');
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
        debugPrint('🌐 Web Image selected');
      } else {
        _imageBytes.value = await image.readAsBytes();
        _imagePath.value = image.path;
        debugPrint('📱 Mobile Image selected: ${image.path}');
      }
    }
  }

  Future<void> _takePhoto() async {
    if (kIsWeb) {
      Get.snackbar('Notice', 'Camera is not supported on Web',
          backgroundColor: AppColor.warning);
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
      debugPrint('📷 Photo taken: ${image.path}');
    }
  }

  Future<void> _createPost() async {
    if (_titleController.text.isEmpty) {
      Get.snackbar('Error', 'Please enter a title',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.error,
          colorText: AppColor.textOnPrimary);
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

      // 1. Create Post
      final createdPost = await controller.createPostDirect(newPost);
      debugPrint('✅ Post created with ID: ${createdPost.id}');

      // ✅ ២. Upload Image (កែត្រឹមត្រូវសម្រាប់ទាំង Web និង Mobile)
      if (createdPost.id != null) {
        if (kIsWeb && _imageBytes.value != null) {
          // សម្រាប់ Web: ប្រើ Bytes
          await controller.uploadPostImageFromBytes(createdPost.id!, _imageBytes.value!);
          debugPrint('✅ Image uploaded successfully (Web)');
        } else if (_imageBytes.value != null) {
          await controller.uploadPostImageFromBytes(createdPost.id!, _imageBytes.value!);
          debugPrint('✅ Image uploaded successfully');
        }
      }

      // 3. Refresh list immediately to update UI
      await controller.fetchPosts();

      Get.snackbar('Success', 'Post created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.success,
          colorText: AppColor.textOnPrimary);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      Get.snackbar('Error', 'Failed to create post: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: AppColor.error,
          colorText: AppColor.textOnPrimary);
    } finally {
      _isUploading.value = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.background,
      appBar: AppBar(
        backgroundColor: AppColor.primary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColor.textOnPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Create Post',
          style: TextStyle(color: AppColor.textOnPrimary, fontWeight: FontWeight.bold),
        ),
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
                  color: AppColor.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColor.primary.withValues(alpha: 0.3),
                  ),
                ),
                child: _imagePath.value.isNotEmpty || (kIsWeb && _imageBytes.value != null)
                    ? ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: kIsWeb && _imageBytes.value != null
                      ? Image.memory(_imageBytes.value!, fit: BoxFit.cover)
                      : (!kIsWeb && _imagePath.value.isNotEmpty)
                      ? Image.file(File(_imagePath.value), fit: BoxFit.cover)
                      : const SizedBox(), // Fallback
                )
                    : const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add_photo_alternate_outlined,
                        size: 50, color: AppColor.primary),
                    SizedBox(height: 8),
                    Text(
                      'Tap to select an image',
                      style: TextStyle(color: AppColor.textSecondary),
                    ),
                  ],
                ),
              ),
            )),

            const SizedBox(height: 24),

            const Text('Title',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColor.textPrimary)),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'My awesome post',
                prefixIcon: const Icon(Icons.title, color: AppColor.primary),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColor.primary),
                ),
                filled: true,
                fillColor: AppColor.surface,
              ),
            ),

            const SizedBox(height: 16),

            const Text('Content',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColor.textPrimary)),
            const SizedBox(height: 8),
            TextField(
              controller: _descController,
              maxLines: 6,
              decoration: InputDecoration(
                hintText: 'Write something...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColor.primary),
                ),
                filled: true,
                fillColor: AppColor.surface,
              ),
            ),

            const SizedBox(height: 24),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Published',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColor.textPrimary)),
                    Text('Visible to everyone',
                        style: TextStyle(color: AppColor.textSecondary, fontSize: 12)),
                  ],
                ),
                Obx(() => Switch(
                  value: _isPublished.value,
                  onChanged: (value) => _isPublished.value = value,
                  activeThumbColor: AppColor.primary,
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
                  backgroundColor: AppColor.primary,
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
                        color: AppColor.textOnPrimary,
                      ),
                    ),
                    SizedBox(width: 12),
                    Text('Creating...',
                        style: TextStyle(color: AppColor.textOnPrimary)),
                  ],
                )
                    : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check, color: AppColor.textOnPrimary),
                    SizedBox(width: 8),
                    Text('Create Post',
                        style: TextStyle(color: AppColor.textOnPrimary, fontSize: 16)),
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
              leading: const Icon(Icons.photo_library, color: AppColor.primary),
              title: const Text('Select from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage();
              },
            ),
            if (!kIsWeb)
              ListTile(
                leading: const Icon(Icons.camera_alt, color: AppColor.primary),
                title: const Text('Take a Photo'),
                onTap: () {
                  Navigator.pop(context);
                  _takePhoto();
                },
              ),
            if (_imagePath.value.isNotEmpty || (kIsWeb && _imageBytes.value != null))
              ListTile(
                leading: const Icon(Icons.delete, color: AppColor.error),
                title: const Text('Remove Image',
                    style: TextStyle(color: AppColor.error)),
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