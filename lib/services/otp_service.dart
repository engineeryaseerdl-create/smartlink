import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';

class OTPService {
  static SupabaseClient? _supabase;

  static Future<void> initialize() async {
    if (_supabase == null) {
      await Supabase.initialize(
        url: SupabaseConfig.supabaseUrl,
        anonKey: SupabaseConfig.supabaseAnonKey,
      );
      _supabase = Supabase.instance.client;
    }
  }

  static Future<bool> sendOTPToEmail(String email) async {
    try {
      await initialize();
      await _supabase!.auth.signInWithOtp(
        email: email,
        emailRedirectTo: null,
      );
      debugPrint('✅ OTP sent to $email');
      return true;
    } catch (e) {
      debugPrint('❌ Error sending OTP: $e');
      return false;
    }
  }

  static Future<bool> verifyOTP(String email, String otp) async {
    try {
      await initialize();
      final response = await _supabase!.auth.verifyOTP(
        type: OtpType.email,
        email: email,
        token: otp,
      );
      debugPrint('✅ OTP verified!');
      return response.session != null;
    } catch (e) {
      debugPrint('❌ Invalid or expired OTP: $e');
      return false;
    }
  }

  static Future<bool> resendOTP(String email) async {
    return await sendOTPToEmail(email);
  }
}
