import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OTPService {
  // TODO: Replace with your Railway URL after deployment
  // Example: 'https://smartlink-otp-production.up.railway.app'
  static const String baseUrl = 'http://localhost:3000'; // Change this after Railway deployment

  static Future<bool> sendOTPToEmail(String email) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ OTP sent to $email');
        return true;
      }
      debugPrint('❌ Failed to send OTP: ${response.body}');
      return false;
    } catch (e) {
      debugPrint('❌ Error sending OTP: $e');
      return false;
    }
  }

  static Future<bool> verifyOTP(String email, String otp) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/verify-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ OTP verified for $email');
        return true;
      }
      debugPrint('❌ Invalid OTP');
      return false;
    } catch (e) {
      debugPrint('❌ Error verifying OTP: $e');
      return false;
    }
  }

  static Future<bool> resendOTP(String email) async {
    return await sendOTPToEmail(email);
  }
}
