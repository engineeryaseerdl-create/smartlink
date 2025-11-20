import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';

class DemoHelper {
  static void showOTPDialog(BuildContext context, String email, String otp) {
    if (!kDebugMode) {
      // Show OTP in dialog for release builds (demo purposes)
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          title: const Text('Demo OTP'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('For demo purposes, your OTP is:'),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green),
                ),
                child: Text(
                  otp,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 4,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'In production, this would be sent to your email.',
                style: TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  }

  static void showDemoInfo(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Demo Mode'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('For demo accounts (test.com emails):'),
            SizedBox(height: 8),
            Text('• Use OTP: 123456'),
            Text('• Or check the OTP dialog'),
            SizedBox(height: 16),
            Text('Demo Accounts:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text('• buyer@test.com'),
            Text('• seller@test.com'),
            Text('• rider@test.com'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }
}