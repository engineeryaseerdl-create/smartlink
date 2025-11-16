import 'package:flutter/material.dart';
import 'dart:async';
import '../../services/otp_service.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';

class OTPVerificationScreen extends StatefulWidget {
  final String email;
  final VoidCallback onVerified;

  const OTPVerificationScreen({
    super.key,
    required this.email,
    required this.onVerified,
  });

  @override
  State<OTPVerificationScreen> createState() => _OTPVerificationScreenState();
}

class _OTPVerificationScreenState extends State<OTPVerificationScreen> {
  final List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  bool _isVerifying = false;
  bool _isResending = false;
  int _resendTimer = 60;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startResendTimer();
  }

  void _startResendTimer() {
    _resendTimer = 60;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendTimer > 0) {
        setState(() => _resendTimer--);
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    for (var controller in _controllers) {
      controller.dispose();
    }
    for (var node in _focusNodes) {
      node.dispose();
    }
    super.dispose();
  }

  String _getOTP() {
    return _controllers.map((c) => c.text).join();
  }

  Future<void> _verifyOTP() async {
    final otp = _getOTP();
    if (otp.length != 6) {
      _showError('Please enter complete OTP');
      return;
    }

    setState(() => _isVerifying = true);

    await Future.delayed(const Duration(milliseconds: 500));

    final isValid = await OTPService.verifyOTP(widget.email, otp);

    setState(() => _isVerifying = false);

    if (isValid) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Email verified successfully!'),
            backgroundColor: AppColors.successGreen,
          ),
        );
        widget.onVerified();
      }
    } else {
      _showError('Invalid or expired OTP');
      _clearOTP();
    }
  }

  Future<void> _resendOTP() async {
    setState(() => _isResending = true);

    final success = await OTPService.resendOTP(widget.email);

    setState(() => _isResending = false);

    if (success) {
      _startResendTimer();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('OTP sent successfully!'),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }
    } else {
      _showError('Failed to resend OTP');
    }
  }

  void _clearOTP() {
    for (var controller in _controllers) {
      controller.clear();
    }
    _focusNodes[0].requestFocus();
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.errorRed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Verify Email'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: AppSpacing.xl),
              const Icon(
                Icons.email_outlined,
                size: 80,
                color: AppColors.primaryGreen,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text(
                'Verify Your Email',
                style: AppTextStyles.heading2,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.sm),
              Text(
                'Enter the 6-digit code sent to',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                widget.email,
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.xxl),
              
              // OTP Input Fields
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(6, (index) {
                  return SizedBox(
                    width: 50,
                    child: TextField(
                      controller: _controllers[index],
                      focusNode: _focusNodes[index],
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.number,
                      maxLength: 1,
                      style: AppTextStyles.heading2,
                      decoration: InputDecoration(
                        counterText: '',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: AppColors.primaryGreen,
                            width: 2,
                          ),
                        ),
                      ),
                      onChanged: (value) {
                        if (value.isNotEmpty && index < 5) {
                          _focusNodes[index + 1].requestFocus();
                        } else if (value.isEmpty && index > 0) {
                          _focusNodes[index - 1].requestFocus();
                        }
                        
                        if (index == 5 && value.isNotEmpty) {
                          _verifyOTP();
                        }
                      },
                    ),
                  );
                }),
              ),
              
              const SizedBox(height: AppSpacing.xl),
              
              // Verify Button
              CustomButton(
                text: 'Verify',
                onPressed: _isVerifying ? null : _verifyOTP,
                isLoading: _isVerifying,
                width: double.infinity,
              ),
              
              const SizedBox(height: AppSpacing.lg),
              
              // Resend OTP
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Didn't receive code? ",
                    style: AppTextStyles.bodyMedium,
                  ),
                  if (_resendTimer > 0)
                    Text(
                      'Resend in ${_resendTimer}s',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    )
                  else
                    TextButton(
                      onPressed: _isResending ? null : _resendOTP,
                      child: _isResending
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Resend'),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
