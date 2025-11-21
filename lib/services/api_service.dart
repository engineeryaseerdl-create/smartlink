import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  final Dio _dio = Dio();
  static const String baseUrl = String.fromEnvironment('API_URL', 
    defaultValue: 'https://smartlink-backend-3eu4.onrender.com/api');
  
  String? _token;

  ApiService() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    _initializeInterceptors();
    _loadToken();
  }

  void _initializeInterceptors() {
    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (_token != null) {
          options.headers['Authorization'] = 'Bearer $_token';
        }
        return handler.next(options);
      },
      onError: (error, handler) async {
        if (error.response?.statusCode == 401) {
          clearAuthToken();
        }
        return handler.next(error);
      },
    ));
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('auth_token');
  }

  Future<void> setAuthToken(String token) async {
    _token = token;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<void> clearAuthToken() async {
    _token = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }

  // Generic methods
  Future<Map<String, dynamic>> get(String path, {Map<String, dynamic>? queryParams}) async {
    try {
      await _ensureTokenLoaded();
      final response = await _dio.get(path, queryParameters: queryParams);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> post(String path, {Map<String, dynamic>? data}) async {
    try {
      await _ensureTokenLoaded();
      final response = await _dio.post(path, data: data);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> put(String path, {Map<String, dynamic>? data}) async {
    try {
      await _ensureTokenLoaded();
      final response = await _dio.put(path, data: data);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> delete(String path) async {
    try {
      await _ensureTokenLoaded();
      final response = await _dio.delete(path);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> _ensureTokenLoaded() async {
    if (_token == null) {
      await _loadToken();
    }
  }



  // Error handling
  String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode == 422) {
            final errors = error.response?.data['errors'] as Map?;
            return errors?.values.first.first ?? 'Validation error';
          }
          final message = error.response?.data['message'] ?? 'Unknown error occurred';
          return 'Error $statusCode: $message';
        case DioExceptionType.cancel:
          return 'Request was cancelled';
        case DioExceptionType.unknown:
          return 'Network error. Please check your internet connection.';
        default:
          return 'An unexpected error occurred';
      }
    }
    return error.toString();
  }
}
