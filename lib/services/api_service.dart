import 'package:dio/dio.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';

class ApiService {
  static final Dio _dio = Dio();
  static const String baseUrl = 'https://your-api-url.com/api';

  // Initialize API service
  static void initialize() {
    _dio.options.baseUrl = baseUrl;
    _dio.options.connectTimeout = const Duration(seconds: 30);
    _dio.options.receiveTimeout = const Duration(seconds: 30);
    
    // Add interceptors for logging, auth tokens, etc.
    _dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
    ));
  }

  // Set auth token
  static void setAuthToken(String token) {
    _dio.options.headers['Authorization'] = 'Bearer $token';
  }

  // Clear auth token
  static void clearAuthToken() {
    _dio.options.headers.remove('Authorization');
  }

  // Auth endpoints
  static Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> register(Map<String, dynamic> userData) async {
    try {
      final response = await _dio.post('/auth/register', data: userData);
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Future<void> logout() async {
    try {
      await _dio.post('/auth/logout');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Product endpoints
  static Future<List<ProductModel>> getProducts({
    String? category,
    String? search,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get('/products', queryParameters: {
        if (category != null) 'category': category,
        if (search != null) 'search': search,
        'page': page,
        'limit': limit,
      });
      
      final List<dynamic> data = response.data['products'];
      return data.map((json) => ProductModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Future<ProductModel> createProduct(ProductModel product) async {
    try {
      final response = await _dio.post('/products', data: product.toJson());
      return ProductModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Future<ProductModel> updateProduct(String id, ProductModel product) async {
    try {
      final response = await _dio.put('/products/$id', data: product.toJson());
      return ProductModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Future<void> deleteProduct(String id) async {
    try {
      await _dio.delete('/products/$id');
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Order endpoints
  static Future<List<OrderModel>> getOrders({
    String? status,
    String? userId,
    int page = 1,
    int limit = 20,
  }) async {
    try {
      final response = await _dio.get('/orders', queryParameters: {
        if (status != null) 'status': status,
        if (userId != null) 'userId': userId,
        'page': page,
        'limit': limit,
      });
      
      final List<dynamic> data = response.data['orders'];
      return data.map((json) => OrderModel.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Future<OrderModel> createOrder(OrderModel order) async {
    try {
      final response = await _dio.post('/orders', data: order.toJson());
      return OrderModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Future<OrderModel> updateOrderStatus(String orderId, OrderStatus status) async {
    try {
      final response = await _dio.put('/orders/$orderId/status', data: {
        'status': status.toString().split('.').last,
      });
      return OrderModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Future<OrderModel> assignRider(String orderId, String riderId) async {
    try {
      final response = await _dio.put('/orders/$orderId/assign-rider', data: {
        'riderId': riderId,
      });
      return OrderModel.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Payment endpoints
  static Future<Map<String, dynamic>> initializePayment({
    required double amount,
    required String email,
    required String orderId,
  }) async {
    try {
      final response = await _dio.post('/payments/initialize', data: {
        'amount': amount,
        'email': email,
        'orderId': orderId,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  static Future<Map<String, dynamic>> verifyPayment(String reference) async {
    try {
      final response = await _dio.get('/payments/verify/$reference');
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // File upload
  static Future<List<String>> uploadImages(List<String> imagePaths) async {
    try {
      final formData = FormData();
      
      for (int i = 0; i < imagePaths.length; i++) {
        formData.files.add(MapEntry(
          'images',
          await MultipartFile.fromFile(imagePaths[i]),
        ));
      }

      final response = await _dio.post('/upload/images', data: formData);
      return List<String>.from(response.data['urls']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Error handling
  static String _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
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