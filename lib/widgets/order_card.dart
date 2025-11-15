import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../models/order_model.dart';
import '../models/rider_model.dart';
import '../providers/rider_provider.dart';
import '../providers/order_provider.dart';
import '../widgets/status_indicator.dart';
import '../utils/constants.dart';
import '../utils/helpers.dart';
import 'rider_selection_sheet.dart';

class OrderCard extends StatelessWidget {
  final OrderModel order;
  final VoidCallback onTap;
  final bool isSellerView;
  final bool showSellerActions;

  const OrderCard({
    super.key,
    required this.order,
    required this.onTap,
    this.isSellerView = false,
    this.showSellerActions = false,
  });

  Color _getStatusColor() {
    switch (order.status) {
      case OrderStatus.pending:
        return AppColors.warningOrange;
      case OrderStatus.confirmed:
        return AppColors.infoBlue;
      case OrderStatus.pickupReady:
        return AppColors.infoBlue;
      case OrderStatus.inTransit:
        return AppColors.primaryGreen;
      case OrderStatus.delivered:
        return AppColors.successGreen;
      case OrderStatus.cancelled:
        return AppColors.errorRed;
    }
  }

  void _showRiderSelection(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => RiderSelectionBottomSheet(order: order),
    );
  }

  void _callRider(String phone) async {
    final uri = Uri.parse('tel:$phone');
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveUtils.isDesktop(context);
    
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.md),
        padding: EdgeInsets.all(isDesktop ? AppSpacing.lg : AppSpacing.md),
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Order #${order.id.length >= 8 ? order.id.substring(0, 8) : order.id}',
                  style: isDesktop
                    ? AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold)
                    : AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: isDesktop ? AppSpacing.md : AppSpacing.sm,
                    vertical: isDesktop ? AppSpacing.sm : 4,
                  ),
                  decoration: BoxDecoration(
                    color: _getStatusColor().withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppBorderRadius.md),
                  ),
                  child: Text(
                    Helpers.getOrderStatusText(order.status.toString().split('.').last),
                    style: isDesktop
                      ? AppTextStyles.bodyMedium.copyWith(
                          color: _getStatusColor(),
                          fontWeight: FontWeight.w600,
                        )
                      : AppTextStyles.bodySmall.copyWith(
                          color: _getStatusColor(),
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                ),
              ],
            ),
            SizedBox(height: isDesktop ? AppSpacing.md : AppSpacing.sm),
            
            if (isDesktop && showSellerActions)
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Customer: ${order.buyerName}',
                          style: AppTextStyles.bodyLarge,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (order.status == OrderStatus.pending) ...[
                    ElevatedButton(
                      onPressed: () {
                        context.read<OrderProvider>().updateOrderStatus(order.id, OrderStatus.confirmed);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryGreen,
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                      child: const Text('Confirm'),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    OutlinedButton(
                      onPressed: () {
                        context.read<OrderProvider>().updateOrderStatus(order.id, OrderStatus.cancelled);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.errorRed,
                        side: const BorderSide(color: AppColors.errorRed),
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.lg,
                          vertical: AppSpacing.sm,
                        ),
                      ),
                      child: const Text('Reject'),
                    ),
                    if (order.status == OrderStatus.confirmed && order.riderId == null) 
                      ElevatedButton.icon(
                        onPressed: () => _showRiderSelection(context),
                        icon: const Icon(Icons.delivery_dining),
                        label: const Text('Assign Rider'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.infoBlue,
                        ),
                      ),
                  ],
                ],
              )
            else
              Text(
                isSellerView
                    ? 'Customer: ${order.buyerName}'
                    : 'Seller: ${order.sellerName}',
                style: isDesktop ? AppTextStyles.bodyLarge : AppTextStyles.bodyMedium,
              ),
            
            if (!isDesktop || !showSellerActions) ...[
              const SizedBox(height: AppSpacing.xs),
              Text(
                '${order.items.length} item${order.items.length > 1 ? 's' : ''}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.grey,
                ),
              ),
            ],
            
            SizedBox(height: isDesktop ? AppSpacing.md : AppSpacing.sm),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  Helpers.formatDateTime(order.createdAt),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey,
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      Helpers.formatCurrency(order.totalAmount),
                      style: isDesktop
                        ? AppTextStyles.heading3.copyWith(color: AppColors.primaryGreen)
                        : AppTextStyles.bodyLarge.copyWith(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryGreen,
                          ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 80,
                      child: OrderProgressBar(
                        progress: _getOrderProgress(order.status),
                        status: order.status.toString().split('.').last,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            
            // Mobile seller actions
            if (!isDesktop && showSellerActions && order.status == OrderStatus.pending) ...[
              const SizedBox(height: AppSpacing.md),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Handle confirm order
                      },
                      child: const Text('Confirm'),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        // Handle reject order
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.errorRed,
                        side: const BorderSide(color: AppColors.errorRed),
                      ),
                      child: const Text('Reject'),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  double _getOrderProgress(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 0.2;
      case OrderStatus.confirmed:
        return 0.4;
      case OrderStatus.pickupReady:
        return 0.6;
      case OrderStatus.inTransit:
        return 0.8;
      case OrderStatus.delivered:
        return 1.0;
      case OrderStatus.cancelled:
        return 0.0;
    }
  }
}
