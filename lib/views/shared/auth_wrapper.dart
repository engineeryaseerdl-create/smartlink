import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import 'home_wrapper.dart';
import '../auth/login_screen.dart';

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        // Show loading screen while checking auth status
        if (authProvider.isLoading) {
          return const Scaffold(
            backgroundColor: AppColors.primaryGreen,
            body: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: AppColors.white),
                  SizedBox(height: AppSpacing.lg),
                  Text(
                    'Loading...',
                    style: TextStyle(
                      color: AppColors.white,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        // If user is logged in, show home wrapper
        if (authProvider.isLoggedIn && authProvider.currentUser != null) {
          return const HomeWrapper();
        }

        // If not logged in, show login screen
        return const LoginScreen();
      },
    );
  }
}