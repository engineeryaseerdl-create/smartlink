# 🎯 Get Your Service ID (10 Seconds)

## You Have:
✅ Template ID: `template_nor1ras`
✅ Public Key: `P4wUtJC-FjeyTGrFq`

## You Need:
❌ Service ID

---

## Get Service ID:

1. Go to: https://dashboard.emailjs.com/admin
2. Click "Email Services" in left sidebar
3. You'll see your Gmail service
4. **Copy the Service ID** (looks like: `service_abc123`)

---

## Then Update Code:

Open: `lib/services/otp_service.dart`

Line 8, replace:
```dart
static const String serviceId = 'YOUR_SERVICE_ID';
```

With:
```dart
static const String serviceId = 'service_YOUR_ID_HERE';
```

---

## ✅ Done!

Then test:
1. Run app
2. Enter email
3. Click "Verify Email with OTP"
4. Check inbox!

🎉 Takes 10 seconds!
