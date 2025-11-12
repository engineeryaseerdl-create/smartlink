import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';
import '../../providers/auth_provider.dart';
import '../../utils/constants.dart';
import '../../widgets/responsive_wrapper.dart';
import '../../widgets/order_card.dart';
import 'order_detail_screen.dart';

class BuyerOrdersContent extends StatelessWidget {
  const BuyerOrdersContent({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.currentUser;
    
    final userOrders = orderProvider.getOrdersForBuyer(user?.id ?? '');

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
          
          if (userOrders.isEmpty)
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
                      'Start shopping to see your orders here',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            SliverPadding(
              padding: ResponsiveUtils.getResponsivePagePadding(context),
              sliver: ResponsiveUtils.isDesktop(context)
                ? _buildDesktopOrdersList(userOrders)
                : _buildMobileOrdersList(userOrders),
            ),
        ],
      ),
    );
  }

  Widget _buildDesktopOrdersList(List orders) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final order = orders[index];
          return Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Card(
              elevation: 2,
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => OrderDetailScreen(order: order),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.lg),
                  child: Row(
                    children: [
                      // Order Info
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Order #${order.id.substring(0, 8)}',
                              style: AppTextStyles.heading3,
                            ),
                            const SizedBox(height: AppSpacing.xs),
                            Text(
                              'From: ${order.sellerName}',
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      // Status
                      Expanded(
                        flex: 2,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                          decoration: BoxDecoration(
                            color: _getStatusColor(order.status).withOpacity(0.1),
                            borderRadius: BorderRadius.circular(AppBorderRadius.md),
                          ),
                          child: Text(
                            _getStatusText(order.status),
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: _getStatusColor(order.status),
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                      
                      // Total
                      Expanded(
                        flex: 1,
                        child: Text(
                          '₦${order.total.toStringAsFixed(0)}',
                          style: AppTextStyles.heading3,
                          textAlign: TextAlign.right,
                        ),
                      ),
                      
                      // Arrow
                      const SizedBox(width: AppSpacing.md),
                      const Icon(
                        Icons.arrow_forward_ios,
                        color: AppColors.grey,
                        size: 16,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
        childCount: orders.length,
      ),
    );
  }

  Widget _buildMobileOrdersList(List orders) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final order = orders[index];
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
            ),
          );
        },
        childCount: orders.length,
      ),
    );
  }

  Color _getStatusColor(status) {
    switch (status.toString()) {
      case 'OrderStatus.pending':
        return AppColors.warningOrange;
      case 'OrderStatus.confirmed':
        return AppColors.infoBlue;
      case 'OrderStatus.shipped':
        return AppColors.primaryGreen;
      case 'OrderStatus.delivered':
        return AppColors.successGreen;
      case 'OrderStatus.cancelled':
        return AppColors.errorRed;
      default:
        return AppColors.grey;
    }
  }

  String _getStatusText(status) {
    switch (status.toString()) {
      case 'OrderStatus.pending':
        return 'Pending';
      case 'OrderStatus.confirmed':
        return 'Confirmed';
      case 'OrderStatus.shipped':
        return 'Shipped';
      case 'OrderStatus.delivered':
        return 'Delivered';
      case 'OrderStatus.cancelled':
        return 'Cancelled';
      default:
        return 'Unknown';
    }
  }
}