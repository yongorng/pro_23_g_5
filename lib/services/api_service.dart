import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/foundation.dart' show debugPrint;
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../model/post_model.dart';

class ApiService {
  static const String baseUrl = 'https://flutter-api.janrent.com';


  String? _authToken;


  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _authToken = prefs.getString('auth_token');
    if (_authToken != null) {
      debugPrint(' Token ត្រូវបានផ្ទុកឡើងវិញពី Storage');
    }
  }


  Future<void> setAuthToken(String token) async {
    _authToken = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
    debugPrint(' Token ត្រូវបានរក្សាទុក');
  }


  Future<void> logout() async {
    _authToken = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    debugPrint('បានចាកចេញ (Token ត្រូវបានលុប)');
  }

  Map<String, String> _getHeaders() {
    final headers = {'Content-Type': 'application/json'};
    if (_authToken != null) {
      headers['Authorization'] = 'Bearer $_authToken';
    }
    return headers;
  }

  Future<bool> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'username': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final token = data['token'];
        if (token != null) {
          await setAuthToken(token);
          debugPrint(' Login successful, token saved');
          return true;
        }
      }
      return false;
    } catch (e) {
      debugPrint(' Login error: $e');
      return false;
    }
  }

  Future<List<PostModel>> getPosts({int page = 0, int size = 100}) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/posts?page=$page&size=$size'),
        headers: _getHeaders(),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData is Map && jsonData.containsKey('data')) {
          final List<dynamic> dataList = jsonData['data'];
          return dataList.map((json) => PostModel.fromMap(json)).toList();
        }
        return [];
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint(' Error fetching posts: $e');
      rethrow;
    }
  }

  Future<PostModel> createPost(PostModel post) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/posts'),
        headers: _getHeaders(),
        body: json.encode(post.toMap()),
      );

      if (response.statusCode == 201 || response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData is Map && jsonData.containsKey('data')) {
          return PostModel.fromMap(jsonData['data']);
        }
        return PostModel.fromMap(jsonData);
      } else {
        throw Exception('Failed to create post: ${response.body}');
      }
    } catch (e) {
      debugPrint(' Error creating post: $e');
      rethrow;
    }
  }

  Future<PostModel> updatePost(PostModel post) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/api/posts/${post.id}'),
        headers: _getHeaders(),
        body: json.encode(post.toMap()),
      );

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData is Map && jsonData.containsKey('data')) {
          return PostModel.fromMap(jsonData['data']);
        }
        return PostModel.fromMap(jsonData);
      } else {
        throw Exception('Failed to update post: ${response.body}');
      }
    } catch (e) {
      debugPrint(' Error updating post: $e');
      rethrow;
    }
  }

  Future<void> deletePost(int id) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/posts/$id'),
        headers: _getHeaders(),
      );

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to delete post: ${response.body}');
      }
    } catch (e) {
      debugPrint(' Error deleting post: $e');
      rethrow;
    }
  }

  Future<PostModel> uploadPostImage(int postId, File imageFile) async {
    try {
      debugPrint('📤 Uploading image to post ID: $postId');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/posts/$postId/image'),
      );

      if (_authToken != null) {
        request.headers['Authorization'] = 'Bearer $_authToken';
      }

      request.files.add(await http.MultipartFile.fromPath(
        'file',
        imageFile.path,
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('📥 Response status: ${streamedResponse.statusCode}');

      if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201) {
        final jsonData = json.decode(response.body);
        if (jsonData is Map && jsonData.containsKey('data')) {
          return PostModel.fromMap(jsonData['data']);
        }
        return PostModel.fromMap(jsonData);
      } else {
        throw Exception('Failed to upload image: ${response.body}');
      }
    } catch (e) {
      debugPrint(' Error uploading image: $e');
      rethrow;
    }
  }

  Future<PostModel> uploadPostImageFromBytes(int postId, Uint8List imageBytes) async {
    try {
      debugPrint('📤 Uploading image from bytes to post ID: $postId');

      var request = http.MultipartRequest(
        'POST',
        Uri.parse('$baseUrl/api/posts/$postId/image'),
      );

      if (_authToken != null) {
        request.headers['Authorization'] = 'Bearer $_authToken';
      }

      request.files.add(http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: 'image.jpg',
      ));

      final streamedResponse = await request.send();
      final response = await http.Response.fromStream(streamedResponse);

      debugPrint('📥 Response status: ${streamedResponse.statusCode}');

      if (streamedResponse.statusCode == 200 || streamedResponse.statusCode == 201) {
        final jsonData = json.decode(response.body);
        if (jsonData is Map && jsonData.containsKey('data')) {
          return PostModel.fromMap(jsonData['data']);
        }
        return PostModel.fromMap(jsonData);
      } else {
        throw Exception('Failed to upload image: ${response.body}');
      }
    } catch (e) {
      debugPrint(' Error uploading image: $e');
      rethrow;
    }
  }
}