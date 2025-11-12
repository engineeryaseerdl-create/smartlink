import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/user_model.dart';
import 'mock_data_service.dart';

class AuthService {
  static const String _userKey = 'current_user';
  static const String _isLoggedInKey = 'is_logged_in';

  Future<UserModel?> login(String email, String password) async {
    await Future.delayed(const Duration(seconds: 1));

    final users = await MockDataService.loadUsers();
    final user = users.firstWhere(
      (u) => u.email == email,
      orElse: () => throw Exception('Invalid credentials'),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
    await prefs.setBool(_isLoggedInKey, true);

    return user;
  }

  Future<UserModel> register({
    required String name,
    required String email,
    required String password,
    required UserRole role,
    required String location,
    String? phone,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    final user = UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      email: email,
      phone: phone,
      role: role,
      location: location,
      isVerified: false,
      createdAt: DateTime.now(),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
    await prefs.setBool(_isLoggedInKey, true);

    return user;
  }

  Future<void> logout() async {
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
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userKey, json.encode(user.toJson()));
  }
}
