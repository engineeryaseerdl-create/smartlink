import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/error_modal.dart';
import '../../widgets/app_logo.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({
    super.key,
    required this.email,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isResetting = false;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    final password = _passwordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (password != confirmPassword) {
      ErrorModal.show(context, 'Passwords do not match');
      return;
    }

    setState(() => _isResetting = true);

    try {
      final authProvider = Provider.of<AuthProvider>(context, listen: false);

      await authProvider.resetPassword(
        widget.email,
        password,
      );

      if (!mounted) return;

      setState(() => _isResetting = false);

      // Show success message and navigate back to login
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Password reset successful! Please login with your new password.'),
          backgroundColor: AppColors.successGreen,
          duration: Duration(seconds: 3),
        ),
      );

      // Navigate back to login screen (clear all previous screens)
      Navigator.of(context).pushNamedAndRemoveUntil(
        '/login',
        (Route<dynamic> route) => false,
      );
    } catch (e) {
      if (mounted) {
        setState(() => _isResetting = false);
        ErrorModal.show(context, 'Failed to reset password: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reset Password'),
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
              const SizedBox(height: AppSpacing.md),
              const Center(
                child: Icon(
                  Icons.lock_reset,
                  size: 60,
                  color: AppColors.primaryGreen,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'Create New Password',
                style: AppTextStyles.heading2.copyWith(
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                'for ${widget.email}',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.lg),

              Form(
                key: _formKey,
                child: Column(
                  children: [
                    // New Password Field
                    CustomTextField(
                      label: 'New Password',
                      hint: 'Enter your new password',
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: _obscurePassword ? Icons.visibility_off : Icons.visibility,
                      onSuffixIconPressed: () {
                        setState(() {
                          _obscurePassword = !_obscurePassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your new password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Confirm Password Field
                    CustomTextField(
                      label: 'Confirm New Password',
                      hint: 'Re-enter your new password',
                      controller: _confirmPasswordController,
                      obscureText: _obscureConfirmPassword,
                      prefixIcon: Icons.lock_outline,
                      suffixIcon: _obscureConfirmPassword ? Icons.visibility_off : Icons.visibility,
                      onSuffixIconPressed: () {
                        setState(() {
                          _obscureConfirmPassword = !_obscureConfirmPassword;
                        });
                      },
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please confirm your new password';
                        }
                        if (value != _passwordController.text) {
                          return 'Passwords do not match';
                        }
                        return null;
                      },
                    ),

                    const SizedBox(height: AppSpacing.md),

                    // Password Requirements
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
                            'Password Requirements:',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          ...[
                            'At least 6 characters long',
                            'Contain letters and numbers (recommended)',
                            'Mix of uppercase and lowercase (recommended)',
                          ].map((requirement) => Padding(
                            padding: const EdgeInsets.only(bottom: 2),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.check_circle_outline,
                                  size: 16,
                                  color: AppColors.primaryGreen,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    requirement,
                                    style: AppTextStyles.bodySmall.copyWith(
                                      color: AppColors.textSecondary,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )).toList(),
                        ],
                      ),
                    ),

                    const SizedBox(height: AppSpacing.lg),

                    // Reset Password Button
                    CustomButton(
                      text: _isResetting ? 'Resetting...' : 'Reset Password',
                      onPressed: _isResetting ? null : _resetPassword,
                      isLoading: _isResetting,
                      width: double.infinity,
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