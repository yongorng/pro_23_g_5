import 'dart:io';
import 'dart:typed_data';
import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile; // ✅ លាក់ FormData និង MultipartFile ពី get
import '../services/api_client.dart';
import '../model/post_model.dart';

class PostRepository {
  final ApiClient _api = Get.find<ApiClient>();

  Future<List<PostModel>> getPosts({int page = 0, int size = 100}) async {
    final data = await _api.get('/api/posts', query: {'page': page, 'size': size});
    if (data.containsKey('data')) {
      return (data['data'] as List).map((json) => PostModel.fromMap(json)).toList();
    }
    return [];
  }

  Future<PostModel> createPost(PostModel post) async {
    final data = await _api.post('/api/posts', body: post.toMap());
    return PostModel.fromMap(data['data'] ?? data);
  }

  Future<PostModel> updatePost(PostModel post) async {
    final data = await _api.put('/api/posts/${post.id}', body: post.toMap());
    return PostModel.fromMap(data['data'] ?? data);
  }

  Future<void> deletePost(int id) async {
    await _api.delete('/api/posts/$id');
  }

  Future<PostModel> uploadImage(int postId, File imageFile) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        imageFile.path,
        filename: 'image.jpg',
      ),
    });

    final response = await _api.dio.post(
      '/api/posts/$postId/image',
      data: formData,
    );

    final data = response.data;
    return PostModel.fromMap(data['data'] ?? data);
  }

  Future<PostModel> uploadImageFromBytes(int postId, Uint8List imageBytes) async {
    final formData = FormData.fromMap({
      'file': MultipartFile.fromBytes(
        imageBytes,
        filename: 'image.jpg',
      ),
    });

    final response = await _api.dio.post(
      '/api/posts/$postId/image',
      data: formData,
    );

    final data = response.data;
    return PostModel.fromMap(data['data'] ?? data);
  }
}