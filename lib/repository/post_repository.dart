import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:get/get.dart' hide FormData, MultipartFile;

import '../services/api_client.dart';
import '../model/post_model.dart';

class PostRepository {
  final ApiClient _api = Get.find<ApiClient>();

  Future<List<PostModel>> getPosts({
    int page = 0,
    int size = 100,
  }) async {
    final data = await _api.get(
      '/api/posts',
      query: {
        'page': page,
        'size': size,
      },
    );

    final postsData = data['data'];

    if (postsData is List) {
      return postsData
          .map(
            (json) => PostModel.fromMap(
              Map<String, dynamic>.from(json as Map),
            ),
          )
          .toList();
    }

    return [];
  }

  Future<PostModel> createPost(PostModel post) async {
    final data = await _api.post(
      '/api/posts',
      body: post.toMap(),
    );

    return PostModel.fromMap(
      Map<String, dynamic>.from(data['data'] ?? data),
    );
  }

  Future<PostModel> updatePost(PostModel post) async {
    final data = await _api.put(
      '/api/posts/${post.id}',
      body: post.toMap(),
    );

    return PostModel.fromMap(
      Map<String, dynamic>.from(data['data'] ?? data),
    );
  }

  Future<void> deletePost(int id) async {
    await _api.delete('/api/posts/$id');
  }

  Future<PostModel> uploadImageFromBytes(
    int postId,
    Uint8List imageBytes,
  ) async {
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

    if (response.statusCode == null ||
        response.statusCode! < 200 ||
        response.statusCode! >= 300) {
      throw Exception(
        data is Map && data['detail'] != null
            ? data['detail'].toString()
            : 'Image upload failed (${response.statusCode})',
      );
    }

    return PostModel.fromMap(
      Map<String, dynamic>.from(data['data'] ?? data),
    );
  }
}
