import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class ResendOTPService {
  static const String _apiKey = 'YOUR_RESEND_API_KEY';
  static const String _baseUrl = 'https://api.resend.com';
  static final Map<String, String> _otpStore = {};

  static Future<bool> sendOTPToEmail(String email) async {
    final otp = (100000 + Random().nextInt(900000)).toString();
    _otpStore[email] = otp;

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/emails'),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'from': 'SmartLink <noreply@smartlink.ng>',
          'to': [email],
          'subject': 'Your SmartLink OTP Code',
          'html': '''
            <h2>Your OTP Code</h2>
            <p>Your verification code is: <strong>$otp</strong></p>
            <p>This code expires in 5 minutes.</p>
          ''',
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ OTP sent via Resend to $email');
        return true;
      }
      
      debugPrint('❌ Resend Error: ${response.body}');
      return false;
    } catch (e) {
      debugPrint('❌ Network Error: $e');
      return false;
    }
  }

  static bool verifyOTP(String email, String otp) {
    return _otpStore[email] == otp;
  }
}
