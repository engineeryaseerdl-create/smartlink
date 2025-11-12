import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryGreen = Color(0xFF00A86B);
  static const Color darkGreen = Color(0xFF008C5A);
  static const Color lightGreen = Color(0xFFE8F5E9);
  static const Color gold = Color(0xFFFFD700);
  static const Color darkGold = Color(0xFFDAA520);
  static const Color white = Color(0xFFFFFFFF);
  static const Color black = Color(0xFF000000);
  static const Color grey = Color(0xFF9E9E9E);
  static const Color lightGrey = Color(0xFFF5F5F5);
  static const Color darkGrey = Color(0xFF424242);
  static const Color errorRed = Color(0xFFD32F2F);
  static const Color successGreen = Color(0xFF388E3C);
  static const Color warningOrange = Color(0xFFFF9800);
  static const Color infoBlue = Color(0xFF1976D2);
  
  // Header Gradient Colors
  static const Color headerGradientStart = Color(0xFF00A86B);
  static const Color headerGradientEnd = Color(0xFF008C5A);
  static const Color headerOverlay = Color(0x1A000000);
  
  // Dark Mode Colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkCard = Color(0xFF2C2C2C);
  static const Color darkText = Color(0xFFE0E0E0);
  static const Color darkTextSecondary = Color(0xFFB0B0B0);
}

class AppTextStyles {
  static const TextStyle heading1 = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const TextStyle heading2 = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.bold,
    height: 1.2,
  );

  static const TextStyle heading3 = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );

  static const TextStyle bodyLarge = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const TextStyle bodyMedium = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const TextStyle bodySmall = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.normal,
    height: 1.5,
  );

  static const TextStyle button = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    height: 1.2,
  );
}

class AppSpacing {
  static const double xs = 4.0;
  static const double sm = 8.0;
  static const double md = 16.0;
  static const double lg = 24.0;
  static const double xl = 32.0;
  static const double xxl = 48.0;
}

class AppBorderRadius {
  static const double sm = 8.0;
  static const double md = 12.0;
  static const double lg = 16.0;
  static const double xl = 24.0;
}

class AppConstants {
  static const String appName = 'SmartLink';
  static const String appTagline = 'Linking Buyers, Sellers & Riders Across Nigeria';
  static const int splashDuration = 2;
}

// Animation Constants
class AppAnimations {
  static const Duration fast = Duration(milliseconds: 200);
  static const Duration medium = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 500);
  static const Duration pageTransition = Duration(milliseconds: 350);
  
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceIn = Curves.elasticIn;
  static const Curve bounceOut = Curves.elasticOut;
  static const Curve slideIn = Curves.decelerate;
}

// Responsive breakpoints
class AppBreakpoints {
  static const double mobile = 480;
  static const double tablet = 768;
  static const double desktop = 1024;
  static const double largeDesktop = 1440;
}

// Responsive utilities
class ResponsiveUtils {
  static bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < AppBreakpoints.tablet;
  }
  
  static bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= AppBreakpoints.tablet && width < AppBreakpoints.desktop;
  }
  
  static bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppBreakpoints.desktop;
  }
  
  static bool isLargeDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= AppBreakpoints.largeDesktop;
  }
  
  static double getResponsivePadding(BuildContext context) {
    if (isDesktop(context)) return AppSpacing.xxl;
    if (isTablet(context)) return AppSpacing.lg;
    return AppSpacing.md;
  }
  
  static int getGridCrossAxisCount(BuildContext context) {
    if (isLargeDesktop(context)) return 6;
    if (isDesktop(context)) return 4;
    if (isTablet(context)) return 3;
    return 2;
  }
  
  static double getMaxContentWidth(BuildContext context) {
    if (isDesktop(context)) return 1200;
    return MediaQuery.of(context).size.width;
  }
  
  static EdgeInsets getResponsivePagePadding(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    if (isDesktop(context)) {
      final horizontalPadding = (screenWidth - getMaxContentWidth(context)) / 2;
      return EdgeInsets.symmetric(
        horizontal: horizontalPadding.clamp(AppSpacing.xl, AppSpacing.xxl * 2),
        vertical: AppSpacing.lg,
      );
    }
    return EdgeInsets.all(getResponsivePadding(context));
  }
}
