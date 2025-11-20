import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

class TwilioOTPService {
  static const String _accountSid = 'YOUR_TWILIO_ACCOUNT_SID';
  static const String _authToken = 'YOUR_TWILIO_AUTH_TOKEN';
  static const String _fromNumber = 'YOUR_TWILIO_PHONE_NUMBER';
  static final Map<String, String> _otpStore = {};

  static Future<bool> sendOTPToPhone(String phoneNumber) async {
    final otp = (100000 + Random().nextInt(900000)).toString();
    _otpStore[phoneNumber] = otp;

    try {
      final credentials = base64Encode(utf8.encode('$_accountSid:$_authToken'));
      
      final response = await http.post(
        Uri.parse('https://api.twilio.com/2010-04-01/Accounts/$_accountSid/Messages.json'),
        headers: {
          'Authorization': 'Basic $credentials',
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: {
          'From': _fromNumber,
          'To': phoneNumber,
          'Body': 'Your SmartLink OTP code is: $otp. Valid for 5 minutes.',
        },
      );

      if (response.statusCode == 201) {
        debugPrint('✅ SMS OTP sent to $phoneNumber');
        return true;
      }
      
      debugPrint('❌ Twilio Error: ${response.body}');
      return false;
    } catch (e) {
      debugPrint('❌ Network Error: $e');
      return false;
    }
  }

  static bool verifyOTP(String phoneNumber, String otp) {
    return _otpStore[phoneNumber] == otp;
  }
}