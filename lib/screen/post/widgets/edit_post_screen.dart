import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../controller/post_controller.dart';
import '../../../model/post_model.dart';
import '../../../theme/app_color.dart';

class EditPostScreen extends StatefulWidget {
  final PostModel post;

  const EditPostScreen({super.key, required this.post});

  @override
  State<EditPostScreen> createState() => _EditPostScreenState();
}

class _EditPostScreenState extends State<EditPostScreen> {
  final PostController controller = Get.find<PostController>();
  final ImagePicker _picker = ImagePicker();

  late TextEditingController _titleController;
  late TextEditingController _descController;

  final RxBool _isPublished = true.obs;
  final RxBool _isUploading = false.obs;
  final Rx<Uint8List?> _imageBytes = Rx<Uint8List?>(null);

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.post.title);
    _descController = TextEditingController(text: widget.post.description);
    _isPublished.value = widget.post.status == 'published';
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    _imageBytes.close();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      imageQuality: 85,
    );

    if (image == null) return;

    _imageBytes.value = await image.readAsBytes();
  }

  Future<void> _updatePost() async {
    if (_titleController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please enter a title',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.error,
        colorText: AppColor.textOnPrimary,
      );
      return;
    }

    _isUploading.value = true;

    try {
      final updatedPost = PostModel(
        id: widget.post.id,
        title: _titleController.text.trim(),
        description: _descController.text,
        status: _isPublished.value ? 'published' : 'draft',
        date: widget.post.date,
        imageUrl: widget.post.imageUrl,
      );

      await controller.updatePost(updatedPost);

      if (widget.post.id != null && _imageBytes.value != null) {
        await controller.uploadPostImageFromBytes(
          widget.post.id!,
          _imageBytes.value!,
        );
      }

      Get.snackbar(
        'Success',
        'Post updated successfully',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.success,
        colorText: AppColor.textOnPrimary,
      );

      if (mounted) Navigator.pop(context);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to update post: $e',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: AppColor.error,
        colorText: AppColor.textOnPrimary,
      );
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
        title: const Text(
          'Edit Post',
          style: TextStyle(color: AppColor.textOnPrimary),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => GestureDetector(
                onTap: _pickImage,
                child: Container(
                  width: double.infinity,
                  height: 200,
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    color: AppColor.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColor.primary.withValues(alpha: 0.3),
                    ),
                  ),
                  child: _imageBytes.value != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: Image.memory(
                            _imageBytes.value!,
                            fit: BoxFit.cover,
                          ),
                        )
                      : widget.post.imageUrl != null &&
                              widget.post.imageUrl!.isNotEmpty
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(16),
                              child: Image.network(
                                widget.post.imageUrl!,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Center(
                                    child: Icon(
                                      Icons.add_photo_alternate_outlined,
                                      size: 50,
                                      color: AppColor.primary,
                                    ),
                                  );
                                },
                              ),
                            )
                          : const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.add_photo_alternate_outlined,
                                  size: 50,
                                  color: AppColor.primary,
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Tap to select an image',
                                  style: TextStyle(
                                    color: AppColor.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Title',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                hintText: 'Post title',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppColor.primary),
                ),
                filled: true,
                fillColor: AppColor.surface,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Content',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColor.textPrimary,
              ),
            ),
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
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Published',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColor.textPrimary,
                      ),
                    ),
                    Text(
                      'Visible to everyone',
                      style: TextStyle(
                        color: AppColor.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Obx(
                  () => Switch(
                    value: _isPublished.value,
                    onChanged: (value) => _isPublished.value = value,
                    activeThumbColor: AppColor.primary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            Obx(
              () => SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: _isUploading.value ? null : _updatePost,
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
                            Text(
                              'Updating...',
                              style: TextStyle(
                                color: AppColor.textOnPrimary,
                              ),
                            ),
                          ],
                        )
                      : const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.save,
                              color: AppColor.textOnPrimary,
                            ),
                            SizedBox(width: 8),
                            Text(
                              'Update Post',
                              style: TextStyle(
                                color: AppColor.textOnPrimary,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
