# ✅ YES! EmailJS Sends Real OTP Emails (1 Minute Setup)

## How It Works:
1. Your Flutter app generates OTP (e.g., 123456)
2. EmailJS sends it to user's email
3. User receives OTP in their inbox
4. User enters OTP in your app
5. Your app verifies it

**No backend needed!** Everything happens in Flutter.

---

## Step 1: Create EmailJS Account (30 sec)

1. Go to: https://dashboard.emailjs.com/sign-up
2. Sign up (FREE - 200 emails/month)
3. Verify your email

---

## Step 2: Add Email Service (1 min)

1. Click "Email Services"
2. Click "Add New Service"
3. Select "Gmail"
4. Click "Connect Account"
5. Allow EmailJS to access Gmail
6. **Copy Service ID** (e.g., `service_abc123`)

---

## Step 3: Create Email Template (1 min)

1. Click "Email Templates"
2. Click "Create New Template"
3. Fill in:
   - **Template Name:** OTP Verification
   - **Subject:** Your SmartLink Verification Code
   - **Content:**
   ```
   Hello,

   Your SmartLink verification code is: {{otp}}

   This code expires in 5 minutes.

   If you didn't request this, please ignore.

   - SmartLink Team
   ```
4. Click "Save"
5. **Copy Template ID** (e.g., `template_xyz789`)

---

## Step 4: Get Public Key (10 sec)

1. Click "Account" in sidebar
2. Click "General"
3. **Copy Public Key** (e.g., `user_abc123xyz`)

---

## Step 5: Update Flutter Code (2 min)

### A. Add Package

In `pubspec.yaml`, add:
```yaml
dependencies:
  http: ^1.1.0
```

Run:
```bash
flutter pub get
```

### B. Replace OTP Service

Replace entire `lib/services/otp_service.dart` with:

```dart
import 'dart:math';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class OTPService {
  // REPLACE THESE WITH YOUR EMAILJS IDs
  static const String serviceId = 'YOUR_SERVICE_ID';
  static const String templateId = 'YOUR_TEMPLATE_ID';
  static const String publicKey = 'YOUR_PUBLIC_KEY';
  
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
            'to_email': email,
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
```

### C. Add Your IDs

Replace in the code above:
- `YOUR_SERVICE_ID` → Your Service ID from Step 2
- `YOUR_TEMPLATE_ID` → Your Template ID from Step 3
- `YOUR_PUBLIC_KEY` → Your Public Key from Step 4

---

## ✅ DONE! Test It Now!

1. Run your Flutter app
2. Enter your email
3. Click "Verify Email with OTP"
4. **Check your email inbox** (OTP will arrive in 2-3 seconds!)
5. Enter the 6-digit code
6. Success! ✅

---

## Example:

**You enter:** test@gmail.com  
**EmailJS sends:** "Your code is: 123456"  
**You receive:** Email in inbox  
**You enter:** 123456  
**App verifies:** ✅ Correct!

---

## Benefits:

✅ **Real emails** sent to user's inbox
✅ **No backend** needed
✅ **No deployment** hassle
✅ **FREE** 200 emails/month
✅ **Works immediately**
✅ **Professional** email templates
✅ **2-3 seconds** delivery

---

## Limits:

- **Free:** 200 emails/month
- **Paid:** $7/month for 1,000 emails
- Perfect for testing and small apps!

---

## Troubleshooting:

**Email not received?**
- Check spam folder
- Verify Service ID, Template ID, Public Key
- Check EmailJS dashboard for errors

**"Failed to send"?**
- Check internet connection
- Verify EmailJS account is active
- Check template has `{{otp}}` variable

---

## 🎉 That's It!

Your SmartLink app now sends **REAL OTP emails** to users!

No backend, no deployment, just works! 🚀
