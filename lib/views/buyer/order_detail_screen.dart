import 'package:flutter/material.dart';
import '../../models/order_model.dart';
import '../../utils/constants.dart';
import '../../utils/helpers.dart';
import '../../widgets/rider_assignment_card.dart';

class OrderDetailScreen extends StatelessWidget {
  final OrderModel order;

  const OrderDetailScreen({super.key, required this.order});

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
      case OrderStatus.modification_requested:
        return AppColors.warningOrange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order #${order.id.length >= 8 ? order.id.substring(0, 8) : order.id}'),
        backgroundColor: AppColors.primaryGreen,
        foregroundColor: AppColors.white,
        iconTheme: const IconThemeData(color: AppColors.white),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: AppSpacing.lg,
            right: AppSpacing.lg,
            top: AppSpacing.lg,
            bottom: MediaQuery.of(context).padding.bottom + AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: _getStatusColor().withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppBorderRadius.md),
                border: Border.all(color: _getStatusColor(), width: 2),
              ),
              child: Row(
                children: [
                  Icon(
                    _getStatusIcon(),
                    color: _getStatusColor(),
                    size: 32,
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Helpers.getOrderStatusText(
                              order.status.toString().split('.').last),
                          style: AppTextStyles.heading3.copyWith(
                            color: _getStatusColor(),
                          ),
                        ),
                        Text(
                          Helpers.formatDateTime(order.createdAt),
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text('Items', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.md),
            ...order.items.map((item) => _buildOrderItem(item)),
            const Divider(),
            const SizedBox(height: AppSpacing.md),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Total Amount:', style: AppTextStyles.heading3),
                Text(
                  Helpers.formatCurrency(order.totalAmount),
                  style: AppTextStyles.heading3.copyWith(
                    color: AppColors.primaryGreen,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            const Text('Delivery Information', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.md),
            _buildInfoRow('Delivery Address', order.buyerLocation),
            _buildInfoRow('Contact', order.buyerPhone),
            if (order.riderName != null) ...[
              const SizedBox(height: AppSpacing.md),
              _buildInfoRow('Rider', order.riderName!),
              _buildInfoRow(
                  'Vehicle Type',
                  order.deliveryType == 'okada'
                      ? 'Motorcycle (Okada)'
                      : 'Car'),
            ],
            const SizedBox(height: AppSpacing.lg),
            RiderAssignmentCard(order: order),
            const SizedBox(height: AppSpacing.lg),
            const Text('Seller Information', style: AppTextStyles.heading3),
            const SizedBox(height: AppSpacing.md),
            _buildInfoRow('Seller', order.sellerName),
            _buildInfoRow('Location', order.sellerLocation),
            const SizedBox(height: AppSpacing.lg),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getStatusIcon() {
    switch (order.status) {
      case OrderStatus.pending:
        return Icons.pending;
      case OrderStatus.confirmed:
        return Icons.check_circle;
      case OrderStatus.pickupReady:
        return Icons.inventory;
      case OrderStatus.inTransit:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.done_all;
      case OrderStatus.cancelled:
        return Icons.cancel;
      case OrderStatus.modification_requested:
        return Icons.edit;
    }
  }

  Widget _buildOrderItem(OrderItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            child: Image.network(
              item.productImage,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 60,
                  height: 60,
                  color: AppColors.lightGrey,
                  child: const Icon(Icons.image),
                );
              },
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.productTitle,
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Qty: ${item.quantity}',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.grey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            Helpers.formatCurrency(item.price * item.quantity),
            style: AppTextStyles.bodyMedium.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
