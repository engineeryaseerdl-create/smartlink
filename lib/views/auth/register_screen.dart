import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/error_modal.dart';
import '../../services/otp_service.dart';
import 'otp_verification_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _locationController = TextEditingController();
  final _businessNameController = TextEditingController();
  bool _obscurePassword = true;
  UserRole _selectedRole = UserRole.buyer;
  String _selectedVehicleType = 'motorcycle';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _locationController.dispose();
    _businessNameController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (!_formKey.currentState!.validate()) return;

    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    try {
      await authProvider.register(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: _selectedRole,
        location: _locationController.text.trim(),
        phone: _phoneController.text.trim(),
        businessName: _selectedRole == UserRole.seller ? _businessNameController.text.trim() : null,
        vehicleType: _selectedRole == UserRole.rider ? _selectedVehicleType : null,
      );

      if (!mounted) return;

      Navigator.of(context).pushReplacementNamed('/auth');
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.darkGrey),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).viewInsets.bottom + AppSpacing.lg,
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Account',
                  style: AppTextStyles.heading1,
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  'Sign up to get started with SmartLink',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                Text(
                  'I want to:',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    Expanded(
                      child: _buildRoleChip(
                        role: UserRole.buyer,
                        label: 'Buy',
                        icon: Icons.shopping_cart,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _buildRoleChip(
                        role: UserRole.seller,
                        label: 'Sell',
                        icon: Icons.store,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: _buildRoleChip(
                        role: UserRole.rider,
                        label: 'Deliver',
                        icon: Icons.delivery_dining,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                CustomTextField(
                  label: 'Full Name',
                  hint: 'Enter your full name',
                  controller: _nameController,
                  prefixIcon: Icons.person_outline,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                CustomTextField(
                  label: 'Email',
                  hint: 'Enter your email',
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
                const SizedBox(height: AppSpacing.md),
                CustomTextField(
                  label: 'Phone Number',
                  hint: 'Enter your phone number',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  prefixIcon: Icons.phone_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your phone number';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                CustomTextField(
                  label: 'Location',
                  hint: 'Enter your location (e.g., Ikeja, Lagos)',
                  controller: _locationController,
                  prefixIcon: Icons.location_on_outlined,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your location';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.md),
                // Seller-specific field
                if (_selectedRole == UserRole.seller)
                  CustomTextField(
                    label: 'Business Name',
                    hint: 'Enter your business name',
                    controller: _businessNameController,
                    prefixIcon: Icons.business,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your business name';
                      }
                      return null;
                    },
                  ),
                if (_selectedRole == UserRole.seller)
                  const SizedBox(height: AppSpacing.md),
                // Rider-specific field
                if (_selectedRole == UserRole.rider)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Vehicle Type',
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.md,
                          vertical: AppSpacing.xs,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.lightGrey,
                          borderRadius: BorderRadius.circular(AppBorderRadius.md),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            value: _selectedVehicleType,
                            isExpanded: true,
                            icon: const Icon(Icons.arrow_drop_down),
                            items: const [
                              DropdownMenuItem(
                                value: 'motorcycle',
                                child: Row(
                                  children: [
                                    Icon(Icons.two_wheeler, size: 20),
                                    SizedBox(width: AppSpacing.sm),
                                    Text('Motorcycle (Okada)'),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'bicycle',
                                child: Row(
                                  children: [
                                    Icon(Icons.pedal_bike, size: 20),
                                    SizedBox(width: AppSpacing.sm),
                                    Text('Bicycle'),
                                  ],
                                ),
                              ),
                              DropdownMenuItem(
                                value: 'car',
                                child: Row(
                                  children: [
                                    Icon(Icons.directions_car, size: 20),
                                    SizedBox(width: AppSpacing.sm),
                                    Text('Car'),
                                  ],
                                ),
                              ),
                            ],
                            onChanged: (value) {
                              setState(() {
                                _selectedVehicleType = value!;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                if (_selectedRole == UserRole.rider)
                  const SizedBox(height: AppSpacing.md),
                CustomTextField(
                  label: 'Password',
                  hint: 'Enter your password',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  prefixIcon: Icons.lock_outline,
                  suffixIcon:
                      _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  onSuffixIconPressed: () {
                    setState(() {
                      _obscurePassword = !_obscurePassword;
                    });
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your password';
                    }
                    if (value.length < 6) {
                      return 'Password must be at least 6 characters';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: AppSpacing.xl),
                CustomButton(
                  text: 'Create Account',
                  onPressed: () async {
                    if (!_formKey.currentState!.validate()) return;

                    final email = _emailController.text.trim();
                    final phone = _phoneController.text.trim();

                    // Show loading
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Row(
                          children: [
                            SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(width: 16),
                            Text('Checking availability...'),
                          ],
                        ),
                        duration: Duration(seconds: 2),
                      ),
                    );

                    // First check if email/phone already exists
                    final authProvider = Provider.of<AuthProvider>(context, listen: false);
                    final checkResult = await authProvider.checkEmailPhoneExists(email, phone);

                    if (checkResult != null && checkResult['errorCode'] != null) {
                      // Show modal error for duplicate email/phone
                      ErrorModal.show(context, checkResult['message']);
                      return;
                    }

                    // If we got here, email and phone are available
                    // Send OTP
                    final success = await OTPService.sendOTPToEmail(email);

                    if (success && mounted) {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => OTPVerificationScreen(
                            email: email,
                            onVerified: () {
                              Navigator.pop(context);
                              _handleRegister();
                            },
                          ),
                        ),
                      );
                    } else {
                      ErrorModal.show(context, 'Failed to send OTP. Please try again.');
                    }
                  },
                  isLoading: authProvider.isLoading,
                  width: double.infinity,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Already have an account? ',
                      style: AppTextStyles.bodyMedium,
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'Login',
                        style: AppTextStyles.button.copyWith(
                          color: AppColors.primaryGreen,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRoleChip({
    required UserRole role,
    required String label,
    required IconData icon,
  }) {
    final isSelected = _selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedRole = role;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppSpacing.md,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryGreen : AppColors.lightGrey,
          borderRadius: BorderRadius.circular(AppBorderRadius.md),
          border: Border.all(
            color: isSelected ? AppColors.primaryGreen : Colors.transparent,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? AppColors.white : AppColors.grey,
              size: 28,
            ),
            const SizedBox(height: AppSpacing.xs),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(
                color: isSelected ? AppColors.white : AppColors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
