import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../utils/token_storage.dart';

class ApiClient {
  static const baseUrl = 'https://flutter-api.janrent.com';

  late final Dio _dio;
  final TokenStorage _tokenStorage;

  ApiClient(this._tokenStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: const Duration(seconds: 20),
        receiveTimeout: const Duration(seconds: 20),
        sendTimeout: const Duration(seconds: 20),
        responseType: ResponseType.json,
        headers: const {'Accept': 'application/json'},
        validateStatus: (_) => true,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (options.path != '/auth/login') {
            final token = _tokenStorage.token;
            if (token != null) {
              options.headers['Authorization'] = 'Bearer $token';
            }
          }

          if (kDebugMode) {
            debugPrint(
              '[API] ${options.method} ${options.uri} '
              'authenticated=${_tokenStorage.hasToken}',
            );
          }

          handler.next(options);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    final response = await _dio.get(path, queryParameters: query);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Object? body,
  }) async {
    final response = await _dio.post(path, data: body);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Object? body,
  }) async {
    final response = await _dio.put(path, data: body);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final response = await _dio.delete(path);
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(Response response) {
    final status = response.statusCode;
    final data = response.data;

    if (status != null && status >= 200 && status < 300) {
      return data is Map
          ? Map<String, dynamic>.from(data)
          : <String, dynamic>{};
    }

    if (status == 401) {
      _tokenStorage.clear();
      if (Get.currentRoute != '/login') {
        Future.microtask(() {
          if (Get.currentRoute != '/login') {
            Get.offAllNamed('/login');
            Get.snackbar(
              'Session expired',
              'Please sign in again.',
              snackPosition: SnackPosition.BOTTOM,
            );
          }
        });
      }
    }

    throw Exception(_errorMessage(data, status));
  }

  String extractAccessToken(Map<String, dynamic> response) {
    final values = <dynamic>[
      response['access_token'],
      response['accessToken'],
      response['token'],
      response['jwt'],
      _nested(response, ['data', 'access_token']),
      _nested(response, ['data', 'accessToken']),
      _nested(response, ['data', 'token']),
      _nested(response, ['data', 'jwt']),
      _nested(response, ['data', 'tokens', 'access_token']),
      _nested(response, ['data', 'tokens', 'accessToken']),
      _nested(response, ['tokens', 'access_token']),
      _nested(response, ['tokens', 'accessToken']),
    ];

    for (final value in values) {
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }

    throw Exception(
      'Login succeeded, but no access token was returned by the server.',
    );
  }

  String? extractRefreshToken(Map<String, dynamic> response) {
    final values = <dynamic>[
      response['refresh_token'],
      response['refreshToken'],
      _nested(response, ['data', 'refresh_token']),
      _nested(response, ['data', 'refreshToken']),
      _nested(response, ['data', 'tokens', 'refresh_token']),
      _nested(response, ['data', 'tokens', 'refreshToken']),
      _nested(response, ['tokens', 'refresh_token']),
      _nested(response, ['tokens', 'refreshToken']),
    ];

    for (final value in values) {
      if (value is String && value.trim().isNotEmpty) {
        return value.trim();
      }
    }
    return null;
  }

  dynamic _nested(Map<String, dynamic> map, List<String> keys) {
    dynamic current = map;
    for (final key in keys) {
      if (current is! Map) return null;
      current = current[key];
    }
    return current;
  }

  String _errorMessage(dynamic data, int? status) {
    if (data is Map) {
      for (final key in ['detail', 'message', 'error']) {
        final value = data[key];
        if (value != null && value.toString().trim().isNotEmpty) {
          return value.toString();
        }
      }
    }

    if (data is String && data.trim().isNotEmpty) {
      return data.trim();
    }

    return status == null ? 'Request failed' : 'Request failed ($status)';
  }
}
