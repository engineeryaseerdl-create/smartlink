import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/otp_service.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/app_logo.dart';
import '../../widgets/error_modal.dart';
import 'otp_verification_screen.dart';

class ForgotPasswordScreen extends StatefulWidget {
  final String email;

  const ForgotPasswordScreen({
    super.key,
    required this.email,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  bool _isSending = false;

  @override
  void initState() {
    super.initState();
    _emailController.text = widget.email;
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendOTP() async {
    final email = _emailController.text.trim();

    if (email.isEmpty) {
      ErrorModal.show(context, 'Please enter your email address');
      return;
    }

    if (!email.contains('@')) {
      ErrorModal.show(context, 'Please enter a valid email address');
      return;
    }

    setState(() => _isSending = true);

    try {
      final success = await OTPService.sendOTPToEmail(email);

      if (!mounted) return;

      setState(() => _isSending = false);

      if (success) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent to your email!'),
            backgroundColor: AppColors.successGreen,
          ),
        );

        // Navigate to OTP verification
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => OTPVerificationScreen(
              email: email,
              onVerified: () {
                // Navigate to reset password screen after OTP verification
                Navigator.of(context).pushNamedAndRemoveUntil(
                  '/reset-password',
                      (Route<dynamic> route) => route.isFirst,
                      arguments: email,
                );
              },
            ),
          ),
        );
      } else {
        ErrorModal.show(context, 'Failed to send OTP. Please try again.');
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isSending = false);
        ErrorModal.show(context, 'An error occurred: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              const Center(
                child: AppLogo(
                  size: 60,
                  backgroundColor: AppColors.primaryGreen,
                  borderRadius: 15,
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Reset Your Password',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Enter your email address and we\'ll send you a verification code to reset your password.',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),

              // Email Input
              CustomTextField(
                label: 'Email',
                hint: 'Enter your email address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icons.email_outlined,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your email';
                  }
                  if (!value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
              ),

              const SizedBox(height: AppSpacing.lg),

              // Send OTP Button
              CustomButton(
                text: _isSending ? 'Sending...' : 'Send OTP',
                onPressed: _isSending ? null : _sendOTP,
                isLoading: _isSending,
                width: double.infinity,
              ),

              const SizedBox(height: AppSpacing.md),

              // Back to Login
              Center(
                child: TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Back to Login',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primaryGreen,
                    ),
                  ),
                ),
              ),

              const SizedBox(height: AppSpacing.lg),

              // Instructions
              Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: AppColors.grey.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppBorderRadius.md),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'How it works:',
                      style: AppTextStyles.bodySmall.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      '1. Enter your email address\n'
                      '2. Check your email for the OTP code\n'
                      '3. Enter the code to verify\n'
                      '4. Create your new password',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}