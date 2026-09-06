import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../repository/post_repository.dart'; //  Repository
import '../model/post_model.dart';

class PostController extends GetxController {
  final PostRepository _repository = PostRepository(); //  PostRepository

  final RxBool isLoading = false.obs;
  final RxList<PostModel> _posts = <PostModel>[].obs;
  final selectedImagePath = RxString('');

  @override
  void onInit() {
    super.onInit();
    fetchPosts();
  }

  Future<void> fetchPosts() async {
    isLoading.value = true;
    try {
      final posts = await _repository.getPosts(size: 100); // Repository
      _posts.clear();
      _posts.addAll(posts);
      print('✅ ទាញយកបានចំនួន: ${posts.length} posts');
    } catch (e) {
      print('❌ Error: $e');
      Get.snackbar('Error', 'Failed to load posts',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  List<PostModel> get posts => _posts;

  List<PostModel> get publishedPosts =>
      _posts.where((post) => post.status == 'published').toList();

  List<PostModel> getFilteredPosts(String query) {
    if (query.isEmpty) return _posts;
    return _posts
        .where((post) => post.title.toLowerCase().contains(query.toLowerCase()))
        .toList();
  }

  Future<PostModel> createPostDirect(PostModel post) async {
    return await _repository.createPost(post); // ✅  Repository
  }

  Future<void> addPost(PostModel post) async {
    try {
      final newPost = await _repository.createPost(post);
      _posts.insert(0, newPost);
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
      final post = await _repository.updatePost(updatedPost); // Repository
      final index = _posts.indexWhere((p) => p.id == post.id);
      if (index != -1) {
        _posts[index] = post;
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
      await _repository.deletePost(postId); // Repository
      _posts.removeWhere((p) => p.id == postId);
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


  Future<void> uploadImage(int postId, dynamic imageSource) async {
    try {
      final updatedPost = await _repository.uploadImage(postId, imageSource);
      final index = _posts.indexWhere((p) => p.id == postId);
      if (index != -1) {
        _posts[index] = updatedPost;
      }
      //
    } catch (e) {
      Get.snackbar('Error', 'Failed to upload image: $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }
}