import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/product_provider.dart';
import '../../providers/order_provider.dart';
import '../../models/order_model.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/responsive_wrapper.dart';
import '../../widgets/animated_widgets.dart';

class SellerDashboardContent extends StatelessWidget {
  const SellerDashboardContent({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final orderProvider = Provider.of<OrderProvider>(context);
    final user = authProvider.currentUser;

    final myProducts = productProvider.products
        .where((p) => p.sellerId == user?.id)
        .toList();
    final myOrders = orderProvider.getOrdersForSeller(user?.id ?? '');
    final pendingOrders =
        myOrders.where((o) => o.status == OrderStatus.pending).toList();

    return Scaffold(
      body: SingleChildScrollView(
        padding: ResponsiveUtils.getResponsivePagePadding(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(user),
            SizedBox(height: ResponsiveUtils.isDesktop(context) 
              ? AppSpacing.xl : AppSpacing.lg),
            _buildStatsSection(myProducts, myOrders, pendingOrders, user),
            SizedBox(height: ResponsiveUtils.isDesktop(context) 
              ? AppSpacing.xl : AppSpacing.lg),
            _buildRecentOrdersSection(myOrders),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(user) {
    return Builder(
      builder: (context) => ResponsiveUtils.isDesktop(context)
        ? _buildDesktopHeader(user)
        : _buildMobileHeader(user),
    );
  }

  Widget _buildDesktopHeader(user) {
    return FadeInWidget(
      slideUp: true,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.xl),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.headerGradientStart,
              AppColors.headerGradientEnd,
            ],
          ),
          borderRadius: BorderRadius.circular(AppBorderRadius.lg),
          boxShadow: [
            BoxShadow(
              color: AppColors.primaryGreen.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SlideInWidget(
                  direction: SlideDirection.left,
                  child: Text(
                    'Welcome to your dashboard, ${user != null && user.name.isNotEmpty ? user.name.split(' ').first : 'Seller'}!',
                    style: AppTextStyles.heading1.copyWith(
                      color: AppColors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                FadeInWidget(
                  delay: const Duration(milliseconds: 200),
                  child: Text(
                    'Manage your products and track your sales performance',
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.white.withOpacity(0.9),
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                if (user?.location != null)
                  FadeInWidget(
                    delay: const Duration(milliseconds: 400),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          size: 18,
                          color: AppColors.white,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          user!.location!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
          ScaleInWidget(
            delay: const Duration(milliseconds: 300),
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.white.withOpacity(0.2),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.white.withOpacity(0.3),
                  width: 3,
                ),
              ),
              child: const Icon(
                Icons.store,
                color: AppColors.white,
                size: 56,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildMobileHeader(user) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hello, ${user != null && user.name.isNotEmpty ? user.name.split(' ').first : 'Seller'}!',
              style: AppTextStyles.heading2,
            ),
            if (user?.location != null)
              Text(
                user!.location!,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.grey,
                ),
              ),
          ],
        ),
        Container(
          width: 50,
          height: 50,
          decoration: const BoxDecoration(
            color: AppColors.primaryGreen,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.store,
            color: AppColors.white,
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(myProducts, myOrders, pendingOrders, user) {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Overview',
            style: ResponsiveUtils.isDesktop(context)
              ? AppTextStyles.heading2
              : AppTextStyles.heading3,
          ),
          SizedBox(height: ResponsiveUtils.isDesktop(context) 
            ? AppSpacing.lg : AppSpacing.md),
          ResponsiveUtils.isDesktop(context)
            ? _buildDesktopStats(myProducts, myOrders, pendingOrders, user)
            : _buildMobileStats(myProducts, myOrders, pendingOrders, user),
        ],
      ),
    );
  }

  Widget _buildDesktopStats(myProducts, myOrders, pendingOrders, user) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: 1.5,
      crossAxisSpacing: AppSpacing.lg,
      mainAxisSpacing: AppSpacing.lg,
      children: [
        _buildStatCard(
          'Products',
          myProducts.length.toString(),
          Icons.inventory,
          AppColors.infoBlue,
          isDesktop: true,
        ),
        _buildStatCard(
          'Total Orders',
          myOrders.length.toString(),
          Icons.shopping_bag,
          AppColors.primaryGreen,
          isDesktop: true,
        ),
        _buildStatCard(
          'Pending Orders',
          pendingOrders.length.toString(),
          Icons.pending,
          AppColors.warningOrange,
          isDesktop: true,
        ),
        _buildStatCard(
          'Rating',
          user?.rating?.toStringAsFixed(1) ?? '0.0',
          Icons.star,
          AppColors.gold,
          isDesktop: true,
        ),
      ],
    );
  }

  Widget _buildMobileStats(myProducts, myOrders, pendingOrders, user) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Products',
                myProducts.length.toString(),
                Icons.inventory,
                AppColors.infoBlue,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatCard(
                'Orders',
                myOrders.length.toString(),
                Icons.shopping_bag,
                AppColors.primaryGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          children: [
            Expanded(
              child: _buildStatCard(
                'Pending',
                pendingOrders.length.toString(),
                Icons.pending,
                AppColors.warningOrange,
              ),
            ),
            const SizedBox(width: AppSpacing.md),
            Expanded(
              child: _buildStatCard(
                'Rating',
                user?.rating?.toStringAsFixed(1) ?? '0.0',
                Icons.star,
                AppColors.gold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(
    String label,
    String value,
    IconData icon,
    Color color, {
    bool isDesktop = false,
  }) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? AppSpacing.lg : AppSpacing.md),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        border: Border.all(
          color: color.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: color,
            size: isDesktop ? 40 : 32,
          ),
          SizedBox(height: isDesktop ? AppSpacing.md : AppSpacing.sm),
          Text(
            value,
            style: isDesktop
              ? AppTextStyles.heading1.copyWith(color: color)
              : AppTextStyles.heading2.copyWith(color: color),
          ),
          Text(
            label,
            style: isDesktop
              ? AppTextStyles.bodyLarge.copyWith(color: color)
              : AppTextStyles.bodySmall.copyWith(color: color),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentOrdersSection(myOrders) {
    return Builder(
      builder: (context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Recent Orders',
                style: ResponsiveUtils.isDesktop(context)
                  ? AppTextStyles.heading2
                  : AppTextStyles.heading3,
              ),
              TextButton(
                onPressed: () {
                  // Navigate to orders page
                },
                child: const Text('View All'),
              ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.isDesktop(context) 
            ? AppSpacing.lg : AppSpacing.md),
          
          if (myOrders.isEmpty)
            Container(
              padding: EdgeInsets.all(ResponsiveUtils.isDesktop(context) 
                ? AppSpacing.xl * 2 : AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.lightGrey,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              ),
              child: Center(
                child: Column(
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: ResponsiveUtils.isDesktop(context) ? 80 : 60,
                      color: AppColors.grey,
                    ),
                    SizedBox(height: ResponsiveUtils.isDesktop(context) 
                      ? AppSpacing.lg : AppSpacing.md),
                    Text(
                      'No orders yet',
                      style: ResponsiveUtils.isDesktop(context)
                        ? AppTextStyles.heading3.copyWith(color: AppColors.grey)
                        : AppTextStyles.bodyLarge.copyWith(color: AppColors.grey),
                    ),
                  ],
                ),
              ),
            )
          else
            ...myOrders.take(ResponsiveUtils.isDesktop(context) ? 5 : 3).map(
              (order) => Container(
                margin: const EdgeInsets.only(bottom: AppSpacing.md),
                padding: EdgeInsets.all(ResponsiveUtils.isDesktop(context) 
                  ? AppSpacing.lg : AppSpacing.md),
                decoration: BoxDecoration(
                  color: AppColors.white,
                  borderRadius: BorderRadius.circular(AppBorderRadius.lg),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Order #${order.id.length >= 8 ? order.id.substring(0, 8) : order.id}',
                            style: ResponsiveUtils.isDesktop(context)
                              ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)
                              : AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            order.buyerName,
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppSpacing.md,
                        vertical: AppSpacing.sm,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(AppBorderRadius.md),
                      ),
                      child: Text(
                        Helpers.getOrderStatusText(
                            order.status.toString().split('.').last),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}