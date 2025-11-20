# Supabase OTP Setup Guide

## Step 1: Create Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Sign up or log in
3. Click "New Project"
4. Fill in:
   - Project Name: `smartlink`
   - Database Password: (create a strong password)
   - Region: Choose closest to Nigeria (e.g., Frankfurt or London)
5. Click "Create new project"

## Step 2: Get Your Credentials

1. In your Supabase dashboard, go to **Settings** → **API**
2. Copy:
   - **Project URL** (looks like: `https://xxxxx.supabase.co`)
   - **anon public key** (long string starting with `eyJ...`)

## Step 3: Configure Your App

Open `lib/config/supabase_config.dart` and replace:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'YOUR_SUPABASE_URL';
  static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
}
```

With your actual credentials:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://xxxxx.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGc...your-key-here';
}
```

## Step 4: Configure Email Settings (Important!)

1. In Supabase dashboard, go to **Authentication** → **Email Templates**
2. Customize the "Magic Link" template (this is used for OTP)
3. Go to **Authentication** → **Settings**
4. Under "Email Auth", ensure:
   - ✅ Enable email confirmations is ON
   - Set "Confirm email" to your preference

## Step 5: Install Dependencies

Run:
```bash
flutter pub get
```

## Step 6: Build and Test

```bash
flutter clean
flutter pub get
flutter build apk --release
```

## How It Works

- User enters email → Supabase sends 6-digit OTP
- User enters OTP → Supabase verifies it
- No backend needed, all handled by Supabase!

## Email Provider (Optional but Recommended)

For production, configure a custom SMTP provider:

1. Go to **Project Settings** → **Auth** → **SMTP Settings**
2. Add your SMTP credentials (Gmail, SendGrid, etc.)
3. This ensures better email deliverability

## Testing

Test emails will be sent to the email address you provide during registration.
Check your spam folder if you don't receive the OTP.

## Troubleshooting

- **OTP not received**: Check Supabase logs in Dashboard → Logs
- **Invalid credentials**: Verify your URL and anon key
- **Email not sent**: Configure custom SMTP provider
