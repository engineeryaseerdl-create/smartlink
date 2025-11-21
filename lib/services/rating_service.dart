import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/rating_model.dart';
import '../utils/constants.dart';

class RatingService {
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  static Future<void> submitRating({
    required String orderId,
    required String revieweeId,
    required String revieweeType,
    required int rating,
    String? comment,
  }) async {
    final token = await _getToken();
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');
    
    if (userJson == null) throw Exception('User not logged in');
    
    final user = json.decode(userJson);
    
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/ratings'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'orderId': orderId,
        'reviewerId': user['id'],
        'reviewerName': user['name'],
        'revieweeId': revieweeId,
        'revieweeType': revieweeType,
        'rating': rating,
        'comment': comment,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to submit rating');
    }
  }

  static Future<List<RatingModel>> getRatings(String userId) async {
    final token = await _getToken();
    
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/ratings/$userId'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['ratings'] as List)
          .map((rating) => RatingModel.fromJson(rating))
          .toList();
    }
    throw Exception('Failed to load ratings');
  }

  static Future<void> submitDispute({
    required String orderId,
    required String disputeType,
    required String description,
  }) async {
    final token = await _getToken();
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString('current_user');
    
    if (userJson == null) throw Exception('User not logged in');
    
    final user = json.decode(userJson);
    
    final response = await http.post(
      Uri.parse('${ApiConstants.baseUrl}/disputes'),
      headers: {
        'Content-Type': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'orderId': orderId,
        'reporterId': user['id'],
        'reporterName': user['name'],
        'disputeType': disputeType,
        'description': description,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to submit dispute');
    }
  }
}
