// OTP Implementation Usage Examples

import 'package:flutter/material.dart';
import '../services/otp_service.dart';
import '../views/auth/otp_verification_screen.dart';

/// Example 1: Send OTP from any screen
void sendOTPExample(BuildContext context, String email) async {
  final success = await OTPService.sendOTPToEmail(email);
  
  if (success) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPVerificationScreen(
          email: email,
          onVerified: () {
            Navigator.pop(context);
            // Continue with your flow
          },
        ),
      ),
    );
  }
}

/// Example 2: Verify email during registration
void registrationWithOTPExample(BuildContext context, String email) async {
  final sent = await OTPService.sendOTPToEmail(email);
  
  if (sent) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPVerificationScreen(
          email: email,
          onVerified: () {
            Navigator.pop(context);
            // Complete registration
          },
        ),
      ),
    );
  }
}

/// Example 3: Password reset with OTP
void passwordResetExample(BuildContext context, String email) async {
  final sent = await OTPService.sendOTPToEmail(email);
  
  if (sent) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OTPVerificationScreen(
          email: email,
          onVerified: () {
            Navigator.pop(context);
            // Navigate to reset password screen
          },
        ),
      ),
    );
  }
}
