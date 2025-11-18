import 'package:flutter/foundation.dart';
import 'dart:convert';
import '../models/user_model.dart';
import '../services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';
  
  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _currentUser != null;
  String? get error => _error;

  Future<void> checkAuthStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('auth_token');
      final userJson = prefs.getString(_userKey);
      
      if (token != null && userJson != null) {
        _currentUser = UserModel.fromJson(json.decode(userJson));
        notifyListeners();
        
        try {
          final response = await _apiService.get('/auth/me');
          if (response['success']) {
            _currentUser = UserModel.fromJson(response['user']);
            await _saveUserToPrefs(_currentUser!);
          }
        } catch (e) {
          debugPrint('Failed to refresh user data: $e');
        }
      }
    } catch (e) {
      debugPrint('Error checking auth status: $e');
      await _clearAuthData();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response['success']) {
        final token = response['token'];
        await _apiService.setAuthToken(token);
        _currentUser = UserModel.fromJson(response['user']);
        await _saveUserToPrefs(_currentUser!);
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    required String location,
    String? phone,
    String? businessName,
    String? vehicleType,
  }) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
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
        _currentUser = UserModel.fromJson(response['user']);
        await _saveUserToPrefs(_currentUser!);
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    await _clearAuthData();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateUserProfile(Map<String, dynamic> updates) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _apiService.put('/users/profile', data: updates);
      
      if (response['success']) {
        _currentUser = UserModel.fromJson(response['user']);
      }
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _saveUserToPrefs(UserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
    await prefs.setBool(_isLoggedInKey, true);
  }

  Future<void> _clearAuthData() async {
    await _apiService.clearAuthToken();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  Future<void> refreshUserData() async {
    if (_currentUser == null) return;
    
    try {
      final response = await _apiService.get('/auth/me');
      if (response['success']) {
        _currentUser = UserModel.fromJson(response['user']);
        await _saveUserToPrefs(_currentUser!);
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Failed to refresh user data: $e');
    }
  }
}
