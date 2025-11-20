import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'services/otp_service.dart';
import 'providers/auth_provider.dart';
import 'providers/product_provider.dart';
import 'providers/order_provider.dart';
import 'providers/rider_provider.dart';
import 'providers/cart_provider.dart';
import 'providers/favorites_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/cluster_provider.dart';
import 'providers/notification_provider.dart';
import 'utils/constants.dart';
import 'views/shared/splash_screen.dart';
import 'views/shared/auth_wrapper.dart';
import 'views/auth/login_screen.dart';
import 'views/auth/forgot_password_screen.dart';
import 'views/auth/reset_password_screen.dart';
import 'views/shared/ux_showcase_screen.dart';
import 'views/buyer/enhanced_buyer_home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await OTPService.initialize();
  runApp(const SmartLinkApp());
}

class SmartLinkApp extends StatelessWidget {
  const SmartLinkApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => RiderProvider()),
        ChangeNotifierProvider(create: (_) => CartProvider()),
        ChangeNotifierProvider(create: (_) => FavoritesProvider()),
        ChangeNotifierProvider(create: (_) => ClusterProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) => MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryGreen,
            primary: AppColors.primaryGreen,
            secondary: AppColors.gold,
          ),
          textTheme: GoogleFonts.interTextTheme(),
          scaffoldBackgroundColor: AppColors.white,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: AppColors.white,
            foregroundColor: AppColors.textPrimary,
            iconTheme: IconThemeData(color: AppColors.textPrimary),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.backgroundLight,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: const BorderSide(
                color: AppColors.primaryGreen,
                width: 2,
              ),
            ),
          ),
        ),
        darkTheme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primaryGreen,
            brightness: Brightness.dark,
            primary: AppColors.primaryGreen,
            secondary: AppColors.gold,
            background: AppColors.darkBackground,
            surface: AppColors.darkSurface,
          ),
          textTheme: GoogleFonts.interTextTheme(ThemeData.dark().textTheme),
          scaffoldBackgroundColor: AppColors.darkBackground,
          appBarTheme: const AppBarTheme(
            elevation: 0,
            centerTitle: true,
            backgroundColor: AppColors.darkSurface,
            foregroundColor: AppColors.darkText,
            iconTheme: IconThemeData(color: AppColors.darkText),
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              foregroundColor: AppColors.white,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
              ),
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: AppColors.darkCard,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
              borderSide: const BorderSide(
                color: AppColors.primaryGreen,
                width: 2,
              ),
            ),
          ),
        ),
        initialRoute: '/',
        onGenerateRoute: (settings) {
          switch (settings.name) {
            case '/':
              return MaterialPageRoute(builder: (context) => const SplashScreen());
            case '/auth':
              return MaterialPageRoute(builder: (context) => const AuthWrapper());
            case '/login':
              return MaterialPageRoute(builder: (context) => const LoginScreen());
            case '/ux-showcase':
              return MaterialPageRoute(builder: (context) => const UXShowcaseScreen());
            case '/enhanced-home':
              return MaterialPageRoute(builder: (context) => const EnhancedBuyerHomeScreen());
            case '/forgot-password':
              final email = settings.arguments as String? ?? '';
              return MaterialPageRoute(
                builder: (context) => ForgotPasswordScreen(email: email),
              );
            case '/reset-password':
              final email = settings.arguments as String? ?? '';
              return MaterialPageRoute(
                builder: (context) => ResetPasswordScreen(email: email),
              );
            default:
              return MaterialPageRoute(
                builder: (context) => const Scaffold(
                  body: Center(child: Text('Page not found')),
                ),
              );
          }
        },
        ),
      ),
    );
  }
}
