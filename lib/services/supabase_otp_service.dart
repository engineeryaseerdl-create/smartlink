import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/foundation.dart';

class SupabaseOTPService {
  static final _supabase = Supabase.instance.client;

  static Future<bool> sendOTPToEmail(String email) async {
    try {
      await _supabase.auth.signInWithOtp(
        email: email,
        emailRedirectTo: 'https://smartlink.ng/auth/callback',
      );
      debugPrint('✅ OTP sent to $email');
      return true;
    } catch (e) {
      debugPrint('❌ Supabase OTP Error: $e');
      return false;
    }
  }

  static Future<bool> verifyOTP(String email, String otp) async {
    try {
      final response = await _supabase.auth.verifyOTP(
        type: OtpType.email,
        token: otp,
        email: email,
      );
      return response.user != null;
    } catch (e) {
      debugPrint('❌ OTP Verification Error: $e');
      return false;
    }
  }
}
