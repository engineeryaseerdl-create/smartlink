import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../models/user_model.dart';
import '../../utils/constants.dart';
import '../../widgets/responsive_wrapper.dart';
import '../../widgets/desktop_sidebar.dart';
import '../buyer/buyer_home_screen.dart';
import '../buyer/buyer_home_content.dart';
import '../buyer/buyer_categories_content.dart';
import '../buyer/buyer_orders_content.dart';
import '../buyer/cart_screen.dart';
import '../seller/seller_home_screen.dart';
import '../seller/seller_dashboard_content.dart';
import '../seller/seller_products_content.dart';
import '../seller/seller_orders_content.dart';
import '../rider/rider_home_screen.dart';
import '../rider/rider_dashboard_content.dart';
import '../rider/rider_orders_content.dart';
import '../shared/profile_content.dart';

class HomeWrapper extends StatefulWidget {
  const HomeWrapper({super.key});

  @override
  State<HomeWrapper> createState() => _HomeWrapperState();
}

class _HomeWrapperState extends State<HomeWrapper> {
  int _selectedIndex = 0;
  UserRole? _lastUserRole;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;

    if (user == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // Reset selected index if user role changed
    if (_lastUserRole != user.role) {
      _selectedIndex = 0;
      _lastUserRole = user.role;
    }

    if (ResponsiveUtils.isDesktop(context)) {
      return _buildDesktopLayout(user);
    } else {
      return _buildMobileLayout(user);
    }
  }

  Widget _buildDesktopLayout(user) {
    final pages = _getPages(user.role);
    final sidebarItems = _getSidebarItems(user.role);

    // Ensure selectedIndex is within bounds
    if (_selectedIndex >= pages.length) {
      _selectedIndex = 0;
    }

    return ResponsiveWrapper(
      showSidebarOnDesktop: true,
      sidebar: DesktopSidebar(
        selectedIndex: _selectedIndex,
        onItemTap: (index) {
          setState(() {
            _selectedIndex = index.clamp(0, pages.length - 1);
          });
        },
        items: sidebarItems,
      ),
      child: pages[_selectedIndex],
    );
  }

  Widget _buildMobileLayout(user) {
    switch (user.role) {
      case UserRole.buyer:
        return const BuyerHomeScreen();
      case UserRole.seller:
        return const SellerHomeScreen();
      case UserRole.rider:
        return const RiderHomeScreen();
      default:
        return const BuyerHomeScreen();
    }
  }

  List<Widget> _getPages(UserRole role) {
    switch (role) {
      case UserRole.buyer:
        return [
          const BuyerHomePage(),
          const BuyerCategoriesPage(),
          const BuyerOrdersPage(),
          const CartPage(),
          const ProfilePage(),
        ];
      case UserRole.seller:
        return [
          const SellerDashboardPage(),
          const SellerProductsPage(),
          const SellerOrdersPage(),
          const ProfilePage(),
        ];
      case UserRole.rider:
        return [
          const RiderDashboardPage(),
          const RiderOrdersPage(),
          const ProfilePage(),
        ];
    }
  }

  List<SidebarItem> _getSidebarItems(UserRole role) {
    switch (role) {
      case UserRole.buyer:
        return const [
          SidebarItem(label: 'Home', icon: Icons.home),
          SidebarItem(label: 'Categories', icon: Icons.category),
          SidebarItem(label: 'Orders', icon: Icons.shopping_bag),
          SidebarItem(label: 'Cart', icon: Icons.shopping_cart),
          SidebarItem(label: 'Profile', icon: Icons.person),
        ];
      case UserRole.seller:
        return const [
          SidebarItem(label: 'Dashboard', icon: Icons.dashboard),
          SidebarItem(label: 'Products', icon: Icons.inventory),
          SidebarItem(label: 'Orders', icon: Icons.shopping_bag),
          SidebarItem(label: 'Profile', icon: Icons.person),
        ];
      case UserRole.rider:
        return const [
          SidebarItem(label: 'Dashboard', icon: Icons.dashboard),
          SidebarItem(label: 'Orders', icon: Icons.delivery_dining),
          SidebarItem(label: 'Profile', icon: Icons.person),
        ];
    }
  }
}

// Desktop-optimized page components
class BuyerHomePage extends StatelessWidget {
  const BuyerHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BuyerHomeContent();
  }
}

class BuyerCategoriesPage extends StatelessWidget {
  const BuyerCategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BuyerCategoriesContent();
  }
}

class BuyerOrdersPage extends StatelessWidget {
  const BuyerOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const BuyerOrdersContent();
  }
}

class SellerDashboardPage extends StatelessWidget {
  const SellerDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SellerDashboardContent();
  }
}

class SellerProductsPage extends StatelessWidget {
  const SellerProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SellerProductsContent();
  }
}

class SellerOrdersPage extends StatelessWidget {
  const SellerOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SellerOrdersContent();
  }
}

class RiderDashboardPage extends StatelessWidget {
  const RiderDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RiderDashboardContent();
  }
}

class RiderOrdersPage extends StatelessWidget {
  const RiderOrdersPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const RiderOrdersContent();
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return const ProfileContent();
  }
}
class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const CartScreen();
  }
}