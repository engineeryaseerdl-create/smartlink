import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import 'api_service.dart';

class AuthService {
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  final ApiService _apiService = ApiService();

  Future<UserModel?> login(String email, String password) async {
    final response = await _apiService.post('/auth/login', data: {
      'email': email,
      'password': password,
    });

    if (response['success']) {
      final token = response['token'];
      await _apiService.setAuthToken(token);
      
      final user = UserModel.fromJson(response['user']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, json.encode(user.toJson()));
      await prefs.setBool(_isLoggedInKey, true);
      
      return user;
    }
    
    throw Exception('Invalid credentials');
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    required String location,
    String? phone,
    String? businessName,
    String? vehicleType,
  }) async {
    final response = await _apiService.post('/auth/register', data: {
      'name': name,
      'email': email,
      'password': password,
      'phone': phone ?? '0800000000',
      'role': role.toString().split('.').last,
      'location': {'address': location},
      if (businessName != null) 'businessName': businessName,
      if (vehicleType != null) 'vehicleType': vehicleType,
    });

    if (response['success']) {
      final token = response['token'];
      await _apiService.setAuthToken(token);
      
      final user = UserModel.fromJson(response['user']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, json.encode(user.toJson()));
      await prefs.setBool(_isLoggedInKey, true);
      
      return user;
    }
    
    throw Exception('Registration failed');
  }

  Future<void> logout() async {
    await _apiService.clearAuthToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson == null) return null;

    return UserModel.fromJson(json.decode(userJson));
  }

  Future<void> updateUser(UserModel user) async {
    final response = await _apiService.put('/users/profile', data: user.toJson());
    
    if (response['success']) {
      final updatedUser = UserModel.fromJson(response['user']);
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, json.encode(updatedUser.toJson()));
    } else {
      throw Exception('Failed to update profile');
    }
  }

  Future<UserModel?> refreshUserData() async {
    try {
      final response = await _apiService.get('/auth/me');
      
      if (response['success']) {
        final user = UserModel.fromJson(response['user']);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString(_userKey, json.encode(user.toJson()));
        return user;
      }
    } catch (e) {
      // If refresh fails, return cached user
      return getCurrentUser();
    }
    return null;
  }
}
