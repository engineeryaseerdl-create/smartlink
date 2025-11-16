import 'dart:math';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OTPService {
  // EmailJS Configuration - NO BACKEND NEEDED!
  static const String serviceId = 'service_5p5j3xj';
  static const String templateId = 'template_jqbwqxh';
  static const String publicKey = 'P4wUtJC-FjeyTGrFq';
  
  static final Map<String, OTPData> _otpStore = {};

  static Future<bool> sendOTPToEmail(String email) async {
    try {
      // Generate 6-digit OTP
      final otp = (100000 + Random().nextInt(900000)).toString();
      
      // Store OTP locally
      _otpStore[email] = OTPData(
        otp: otp,
        expiryTime: DateTime.now().add(const Duration(minutes: 5)),
      );

      // Send email via EmailJS
      final response = await http.post(
        Uri.parse('https://api.emailjs.com/api/v1.0/email/send'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'service_id': serviceId,
          'template_id': templateId,
          'user_id': publicKey,
          'template_params': {
            'to_name': email,
            'to_email': email,
            'user_email': email,
            'passcode': otp,
            'otp': otp,
          },
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('✅ OTP sent to $email: $otp');
        return true;
      }
      
      debugPrint('❌ Failed: ${response.body}');
      return false;
    } catch (e) {
      debugPrint('❌ Error: $e');
      return false;
    }
  }

  static Future<bool> verifyOTP(String email, String otp) async {
    final stored = _otpStore[email];
    
    if (stored == null) {
      debugPrint('❌ No OTP found for $email');
      return false;
    }

    if (DateTime.now().isAfter(stored.expiryTime)) {
      _otpStore.remove(email);
      debugPrint('❌ OTP expired');
      return false;
    }

    if (stored.otp == otp) {
      _otpStore.remove(email);
      debugPrint('✅ OTP verified!');
      return true;
    }

    debugPrint('❌ Invalid OTP');
    return false;
  }

  static Future<bool> resendOTP(String email) async {
    return await sendOTPToEmail(email);
  }
}

class OTPData {
  final String otp;
  final DateTime expiryTime;
  OTPData({required this.otp, required this.expiryTime});
}
