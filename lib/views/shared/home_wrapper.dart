import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../buyer/buyer_home_screen.dart';
import '../seller/seller_home_screen.dart';
import '../rider/rider_home_screen.dart';

class HomeWrapper extends StatelessWidget {
  const HomeWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    switch (user.role) {
      case UserRole.buyer:
        return const BuyerHomeScreen();
      case UserRole.seller:
        return const SellerHomeScreen();
      case UserRole.rider:
        return const RiderHomeScreen();
    }
  }
}
