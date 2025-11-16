# 📱 Registration Flow with OTP

## How It Works:

```
User fills registration form
         ↓
Clicks "Create Account"
         ↓
App sends OTP to email (2-3 seconds)
         ↓
Shows "Sending OTP..." message
         ↓
Navigates to OTP Verification Screen
         ↓
User checks email inbox
         ↓
User enters 6-digit OTP
         ↓
App verifies OTP
         ↓
Account created! ✅
         ↓
User logged in automatically
```

---

## Step-by-Step:

### 1. User Fills Form
- Name: John Doe
- Email: john@gmail.com
- Phone: 08012345678
- Location: Lagos, Nigeria
- Password: ******

### 2. Clicks "Create Account"
- App validates form
- Shows "Sending OTP to your email..."
- Sends OTP via EmailJS

### 3. Email Sent
User receives:
```
From: SmartLink
Subject: Your SmartLink Verification Code

Your verification code is: 123456

Expires in 5 minutes.
```

### 4. OTP Screen Appears
- 6 input boxes for OTP
- "Resend OTP" button (60s countdown)
- Auto-focuses between boxes
- Auto-verifies when 6 digits entered

### 5. User Enters OTP
- Types: 1 2 3 4 5 6
- App verifies instantly
- Shows success message

### 6. Account Created
- Registration completes
- User logged in
- Redirected to dashboard

---

## Test It:

```bash
flutter run
```

1. Click "Sign Up"
2. Fill form with YOUR REAL EMAIL
3. Click "Create Account"
4. Wait 2-3 seconds
5. Check email inbox
6. Enter OTP code
7. Done! ✅

---

## What You'll See:

**Console Output:**
```
✅ OTP sent to john@gmail.com: 123456
```

**Email Received:**
```
Your SmartLink verification code is: 123456
```

**OTP Screen:**
```
┌─────────────────────────────┐
│   Verify Your Email         │
│                             │
│   Enter the 6-digit code    │
│   sent to john@gmail.com    │
│                             │
│   [1] [2] [3] [4] [5] [6]  │
│                             │
│   Didn't receive code?      │
│   Resend in 60s             │
│                             │
│   [Verify Button]           │
└─────────────────────────────┘
```

---

## Features:

✅ Real OTP emails
✅ Auto-focus between inputs
✅ 60-second resend timer
✅ 5-minute OTP expiry
✅ Beautiful UI
✅ Loading states
✅ Error handling

---

🎉 Professional OTP flow, no backend needed!
