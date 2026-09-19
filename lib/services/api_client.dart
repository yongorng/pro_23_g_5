import 'package:dio/dio.dart';
import '../utils/token_storage.dart';

class ApiClient {
  late final Dio _dio;
  final TokenStorage _tokenStorage;

  ApiClient(this._tokenStorage) {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'https://flutter-api.janrent.com',
        connectTimeout: const Duration(seconds: 15),
        receiveTimeout: const Duration(seconds: 15),
        sendTimeout: const Duration(seconds: 15),
        responseType: ResponseType.json,
        validateStatus: (_) => true,
      ),
    );

    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = _tokenStorage.token;

          if (token != null && token.isNotEmpty) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          return handler.next(options);
        },
      ),
    );
  }

  Dio get dio => _dio;

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, dynamic>? query,
  }) async {
    final response = await _dio.get(
      path,
      queryParameters: query,
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(
    String path, {
    Object? body,
  }) async {
    final response = await _dio.post(
      path,
      data: body,
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(
    String path, {
    Object? body,
  }) async {
    final response = await _dio.put(
      path,
      data: body,
    );

    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final response = await _dio.delete(path);
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(Response response) {
    final statusCode = response.statusCode;
    final data = response.data;

    if (statusCode != null && statusCode >= 200 && statusCode < 300) {
      if (data is Map) {
        return Map<String, dynamic>.from(data);
      }

      return {};
    }

    if (statusCode == 401) {
      _tokenStorage.clear();
    }

    String message = 'Request failed';

    if (data is Map && data['detail'] != null) {
      message = data['detail'].toString();
    } else if (data is String && data.isNotEmpty) {
      message = data;
    } else if (statusCode != null) {
      message = 'Request failed ($statusCode)';
    }

    throw Exception(message);
  }
}
