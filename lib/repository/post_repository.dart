import 'dart:io';
import 'dart:typed_data';
import '../model/post_model.dart';
import '../services/api_service.dart';

class PostRepository {
  // បង្កើត instance នៃ ApiService
  final ApiService _apiService = ApiService();

  /// ទាញយក Post ទាំងអស់
  Future<List<PostModel>> getPosts({int page = 0, int size = 100}) async {
    try {
      return await _apiService.getPosts(page: page, size: size);
    } catch (e) {
      throw Exception('Failed to fetch posts: $e');
    }
  }

  /// បង្កើត Post ថ្មី
  Future<PostModel> createPost(PostModel post) async {
    try {
      return await _apiService.createPost(post);
    } catch (e) {
      throw Exception('Failed to create post: $e');
    }
  }

  /// កែ Post
  Future<PostModel> updatePost(PostModel post) async {
    try {
      return await _apiService.updatePost(post);
    } catch (e) {
      throw Exception('Failed to update post: $e');
    }
  }

  /// លុប Post
  Future<void> deletePost(int id) async {
    try {
      await _apiService.deletePost(id);
    } catch (e) {
      throw Exception('Failed to delete post: $e');
    }
  }

  /// pload រូបភាព
  Future<PostModel> uploadImage(int postId, dynamic imageSource) async {
    try {
      if (imageSource is File) {
        //  Mobile
        return await _apiService.uploadPostImage(postId, imageSource);
      } else if (imageSource is Uint8List) {
        //  Web
        return await _apiService.uploadPostImageFromBytes(postId, imageSource);
      } else {
        throw Exception('Invalid image source type');
      }
    } catch (e) {
      throw Exception('Failed to upload image: $e');
    }
  }
}