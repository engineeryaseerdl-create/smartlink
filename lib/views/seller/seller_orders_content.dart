import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/responsive_wrapper.dart';
import '../../widgets/order_card.dart';
import '../buyer/order_detail_screen.dart';

class SellerOrdersContent extends StatelessWidget {
  const SellerOrdersContent({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    
    final myOrders = orderProvider.getOrdersForSeller(user?.id ?? '');

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Container(
              padding: ResponsiveUtils.getResponsivePagePadding(context),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Orders',
                    style: ResponsiveUtils.isDesktop(context)
                      ? AppTextStyles.heading1
                      : AppTextStyles.heading2,
                  ),
                  SizedBox(height: ResponsiveUtils.isDesktop(context) 
                    ? AppSpacing.xl : AppSpacing.lg),
                ],
              ),
            ),
          ),
          
          if (myOrders.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.shopping_bag_outlined,
                      size: ResponsiveUtils.isDesktop(context) ? 120 : 80,
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
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      'Orders will appear here when customers purchase your products',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: ResponsiveUtils.getResponsivePagePadding(context),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    final order = myOrders[index];
                    return Container(
                      margin: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: OrderCard(
                        order: order,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OrderDetailScreen(order: order),
                            ),
                          );
                        },
                        showSellerActions: true, // Show actions for seller
                      ),
                    );
                  },
                  childCount: myOrders.length,
                ),
              ),
            ),
        ],
      ),
    );
  }
}