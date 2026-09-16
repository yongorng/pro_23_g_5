import 'dart:io';
import 'dart:typed_data';
import '../services/api_service.dart';
import '../model/post_model.dart';

class PostRepository {
  final ApiService _apiService = ApiService();

  Future<List<PostModel>> getPosts({int page = 0, int size = 100}) async {
    return await _apiService.getPosts(page: page, size: size);
  }

  Future<PostModel> createPost(PostModel post) async {
    return await _apiService.createPost(post);
  }

  Future<PostModel> updatePost(PostModel post) async {
    return await _apiService.updatePost(post);
  }

  Future<void> deletePost(int id) async {
    await _apiService.deletePost(id);
  }


  Future<PostModel> uploadImage(int postId, File imageFile) async {
    return await _apiService.uploadPostImage(postId, imageFile);
  }


  Future<PostModel> uploadImageFromBytes(int postId, Uint8List imageBytes) async {
    return await _apiService.uploadPostImageFromBytes(postId, imageBytes);
  }
}