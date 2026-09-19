import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repository/post_repository.dart';
import '../model/post_model.dart';
import '../theme/app_color.dart';

class PostController extends GetxController {
  final PostRepository _repository = PostRepository();

  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;

  final RxList<PostModel> _allPosts = <PostModel>[].obs;
  final RxList<PostModel> _visiblePosts = <PostModel>[].obs;

  final RxInt visibleCount = 10.obs;
  final int loadIncrement = 1;

  final selectedImagePath = RxString('');

  @override
  void onInit() {
    super.onInit();

  }

  Future<void> fetchPosts() async {
    isLoading.value = true;
    visibleCount.value = 10;

    try {
      final posts = await _repository.getPosts(size: 100);
      _allPosts.clear();
      _allPosts.addAll(posts);

      _updateVisiblePosts();

      debugPrint('✅ ទាញយកបានចំនួន: ${posts.length} posts');
    } catch (e) {
      debugPrint('❌ Error: $e');
      Get.snackbar('Error', 'Failed to load posts',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  void _updateVisiblePosts() {
    _visiblePosts.clear();
    final count = visibleCount.value > _allPosts.length
        ? _allPosts.length
        : visibleCount.value;

    for (int i = 0; i < count; i++) {
      _visiblePosts.add(_allPosts[i]);
    }
  }

  Future<void> loadMorePosts() async {
    if (isLoadingMore.value) return;

    isLoadingMore.value = true;

    try {
      await Future.delayed(const Duration(milliseconds: 100));

      if (visibleCount.value >= _allPosts.length) {
        visibleCount.value = 10;
        debugPrint('🔄 Looping back to start! Showing 10/${_allPosts.length}');

        Get.snackbar('Info', 'Back to top',
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 1),
            backgroundColor: AppColor.primary,
            colorText: Colors.white);
      } else {
        visibleCount.value += loadIncrement;
        if (visibleCount.value > _allPosts.length) {
          visibleCount.value = _allPosts.length;
        }
        debugPrint('📄 Loaded: ${visibleCount.value}/${_allPosts.length}');
      }

      _updateVisiblePosts();
    } catch (e) {
      debugPrint('❌ Error loading more: $e');
    } finally {
      isLoadingMore.value = false;
    }
  }

  // ✅ Getters
  List<PostModel> get posts => _visiblePosts;
  List<PostModel> get allPosts => _allPosts;

  List<PostModel> get publishedPosts =>
      _allPosts.where((post) => post.status == 'published').toList();

  List<PostModel> getFilteredPosts(String query) {
    if (query.isEmpty) return _allPosts;
    return _allPosts
        .where((post) => post.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<PostModel> createPostDirect(PostModel post) async {
    return await _repository.createPost(post);
  }

  Future<void> addPost(PostModel post) async {
    try {
      final newPost = await _repository.createPost(post);
      _allPosts.insert(0, newPost);
      visibleCount.value++;
      _updateVisiblePosts();
      Get.snackbar('Success', 'Post created successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to create post',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> updatePost(PostModel updatedPost) async {
    try {
      final post = await _repository.updatePost(updatedPost);
      final index = _allPosts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        _allPosts[index] = post;
        _updateVisiblePosts();
      }
      Get.snackbar('Success', 'Post updated successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to update post',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> deletePost(int postId) async {
    try {
      await _repository.deletePost(postId);
      _allPosts.removeWhere((p) => p.id == postId);
      if (visibleCount.value > _allPosts.length) {
        visibleCount.value = _allPosts.length;
      }
      _updateVisiblePosts();
      Get.snackbar('Deleted', 'Post deleted successfully',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } catch (e) {
      Get.snackbar('Error', 'Failed to delete post',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  Future<void> togglePublishStatus(PostModel post) async {
    final newStatus = post.status == 'published' ? 'draft' : 'published';
    final updatedPost = post.copyWith(status: newStatus);
    await updatePost(updatedPost);
  }

  void setSelectedImage(String? path) {
    selectedImagePath.value = path ?? '';
  }

  Future<void> uploadPostImageFromBytes(int postId, Uint8List imageBytes) async {
    try {
      final updatedPost = await _repository.uploadImageFromBytes(postId, imageBytes);
      final index = _allPosts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _allPosts[index] = updatedPost;
        _updateVisiblePosts();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      rethrow;
    }
  }

  Future<void> uploadPostImage(int postId, File imageFile) async {
    try {
      final updatedPost = await _repository.uploadImage(postId, imageFile);
      final index = _allPosts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _allPosts[index] = updatedPost;
        _updateVisiblePosts();
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      rethrow;
    }
  }
}