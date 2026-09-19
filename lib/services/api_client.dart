import 'package:dio/dio.dart';
import '../utils/token_storage.dart';

class ApiClient {
  late final Dio _dio;
  final TokenStorage _tokenStorage;

  ApiClient(this._tokenStorage) {
    _dio = Dio(BaseOptions(
      baseUrl: 'https://flutter-api.janrent.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
      contentType: Headers.jsonContentType,
      validateStatus: (_) => true,
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        final String? token = _tokenStorage.token;
        if (token != null && token.isNotEmpty) {
          options.headers['Authorization'] = 'Bearer $token';
        }
        return handler.next(options);
      },
    ));
  }

  Dio get dio => _dio;

  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? query}) async {
    final response = await _dio.get(path, queryParameters: query);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> post(String path, {Object? body}) async {
    final response = await _dio.post(path, data: body);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> put(String path, {Object? body}) async {
    final response = await _dio.put(path, data: body);
    return _handleResponse(response);
  }

  Future<Map<String, dynamic>> delete(String path) async {
    final response = await _dio.delete(path);
    return _handleResponse(response);
  }

  Map<String, dynamic> _handleResponse(Response response) {
    if (response.statusCode != null && response.statusCode! >= 200 && response.statusCode! < 300) {
      return response.data is Map<String, dynamic> ? response.data : {};
    }

    if (response.statusCode == 401) {
      _tokenStorage.clear();
    }

    throw Exception(response.data['detail'] ?? 'Request failed (${response.statusCode})');
  }
}