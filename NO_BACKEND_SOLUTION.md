# 🎯 NO BACKEND NEEDED - Use EmailJS (1 Minute Setup)

## Simplest Solution Ever!

No backend, no deployment, no GitHub. Just 1 minute setup!

---

## Step 1: Create EmailJS Account (30 sec)

1. Go to: https://www.emailjs.com
2. Sign up (FREE - 200 emails/month)
3. Verify your email

---

## Step 2: Setup Email Service (30 sec)

1. Click "Email Services" > "Add New Service"
2. Select "Gmail"
3. Click "Connect Account"
4. Allow access
5. Copy the **Service ID** (e.g., `service_abc123`)

---

## Step 3: Create Email Template (30 sec)

1. Click "Email Templates" > "Create New Template"
2. Template Name: "OTP Verification"
3. Subject: `SmartLink Verification Code`
4. Content:
```
Hello,

Your SmartLink verification code is: {{otp}}

This code expires in 5 minutes.

If you didn't request this, ignore this email.
```
5. Save
6. Copy the **Template ID** (e.g., `template_xyz789`)

---

## Step 4: Get Public Key (10 sec)

1. Click "Account" > "General"
2. Copy your **Public Key** (e.g., `user_abc123xyz`)

---

## Step 5: Update Flutter (1 min)

Add package to `pubspec.yaml`:
```yaml
dependencies:
  emailjs: ^3.0.0
```

Run:
```bash
flutter pub get
```

Replace `lib/services/otp_service.dart` with:

```dart
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:emailjs/emailjs.dart';

class OTPService {
  static const String serviceId = 'YOUR_SERVICE_ID';
  static const String templateId = 'YOUR_TEMPLATE_ID';
  static const String publicKey = 'YOUR_PUBLIC_KEY';
  
  static final Map<String, OTPData> _otpStore = {};

  static Future<bool> sendOTPToEmail(String email) async {
    try {
      final otp = (100000 + Random().nextInt(900000)).toString();
      _otpStore[email] = OTPData(
        otp: otp,
        expiryTime: DateTime.now().add(Duration(minutes: 5)),
      );

      await EmailJS.send(
        serviceId,
        templateId,
        {
          'to_email': email,
          'otp': otp,
        },
        Options(publicKey: publicKey),
      );

      debugPrint('✅ OTP sent to $email');
      return true;
    } catch (e) {
      debugPrint('❌ Error: $e');
      return false;
    }
  }

  static Future<bool> verifyOTP(String email, String otp) async {
    final stored = _otpStore[email];
    if (stored == null) return false;
    if (DateTime.now().isAfter(stored.expiryTime)) {
      _otpStore.remove(email);
      return false;
    }
    if (stored.otp == otp) {
      _otpStore.remove(email);
      return true;
    }
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
```

Replace:
- `YOUR_SERVICE_ID` with your Service ID
- `YOUR_TEMPLATE_ID` with your Template ID
- `YOUR_PUBLIC_KEY` with your Public Key

---

## ✅ DONE!

Test:
1. Run Flutter app
2. Enter email
3. Click "Verify Email with OTP"
4. Check inbox
5. Enter code

---

## Benefits:

✅ No backend needed
✅ No deployment
✅ No GitHub
✅ 1 minute setup
✅ FREE (200 emails/month)
✅ Works immediately
✅ No server maintenance

---

## Limits:

- 200 emails/month (FREE)
- Upgrade to 1000 emails/month for $7

Perfect for testing and small apps!

🎉 Simplest solution ever!
