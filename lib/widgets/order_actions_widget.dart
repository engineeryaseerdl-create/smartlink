import 'package:flutter/material.dart';
import '../../utils/constants.dart';
import '../../models/order_model.dart';

class OrderActionsWidget extends StatelessWidget {
  final OrderModel order;
  final Function(String) onCancelOrder;
  final Function(String) onModifyOrder;

  const OrderActionsWidget({
    super.key,
    required this.order,
    required this.onCancelOrder,
    required this.onModifyOrder,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Order Status
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: BoxDecoration(
              color: _getStatusColor(order.status),
              borderRadius: BorderRadius.circular(AppBorderRadius.sm),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  _getStatusIcon(order.status),
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  _getStatusText(order.status),
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.sm),

          // Action Buttons
          if (order.status == OrderStatus.pending || order.status == OrderStatus.confirmed) ...[
            _buildActionButton(
              icon: Icons.edit,
              label: 'Modify Order',
              color: AppColors.primaryGreen,
              onPressed: () => onModifyOrder(order.id),
            ),
            const SizedBox(width: AppSpacing.sm),
            _buildActionButton(
              icon: Icons.cancel,
              label: 'Cancel Order',
              color: AppColors.errorRed,
              onPressed: () => _showCancelConfirmation(context),
            ),
          ],

          // Delivery Information (if delivered)
          if (order.status == OrderStatus.delivered) ...[
            const SizedBox(height: AppSpacing.md),
            Container(
              padding: const EdgeInsets.all(AppSpacing.sm),
              decoration: BoxDecoration(
                color: AppColors.successGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(AppBorderRadius.sm),
              ),
              child: Row(
                children: [
                  const Icon(Icons.check_circle, color: AppColors.successGreen),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    'Delivered on ${order.deliveredAt?.day ?? ''}',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.successGreen),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppBorderRadius.sm),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(width: AppSpacing.sm),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.grey;
      case OrderStatus.confirmed:
        return AppColors.primaryGreen;
      case OrderStatus.assigned:
        return AppColors.infoBlue;
      case OrderStatus.pickedUp:
        return AppColors.primaryGreen;
      case OrderStatus.inTransit:
        return AppColors.warningOrange;
      case OrderStatus.delivered:
        return AppColors.successGreen;
      case OrderStatus.completed:
        return AppColors.successGreen;
      case OrderStatus.refunded:
        return AppColors.warningOrange;
      case OrderStatus.cancelled:
        return AppColors.errorRed;
      case OrderStatus.modification_requested:
        return AppColors.warningOrange;
    }
  }

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.pending_actions;
      case OrderStatus.confirmed:
        return Icons.check_circle;
      case OrderStatus.assigned:
        return Icons.person;
      case OrderStatus.pickedUp:
        return Icons.local_shipping;
      case OrderStatus.inTransit:
        return Icons.local_shipping;
      case OrderStatus.delivered:
        return Icons.check_circle;
      case OrderStatus.completed:
        return Icons.check_circle_outline;
      case OrderStatus.refunded:
        return Icons.money_off;
      case OrderStatus.cancelled:
        return Icons.cancel;
      case OrderStatus.modification_requested:
        return Icons.edit;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Order Pending';
      case OrderStatus.confirmed:
        return 'Order Confirmed';
      case OrderStatus.assigned:
        return 'Assigned to Rider';
      case OrderStatus.pickedUp:
        return 'Picked Up';
      case OrderStatus.inTransit:
        return 'Out for Delivery';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.completed:
        return 'Completed';
      case OrderStatus.refunded:
        return 'Refunded';
      case OrderStatus.cancelled:
        return 'Cancelled';
      case OrderStatus.modification_requested:
        return 'Modification Requested';
    }
  }

  void _showCancelConfirmation(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber,
              color: AppColors.warningOrange,
              size: 48,
            ),
            const SizedBox(height: AppSpacing.md),
            const Text(
              'Are you sure you want to cancel this order?',
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              'This action cannot be undone. The seller will be notified and may process a refund if applicable.',
              style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Keep Order'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              onCancelOrder(order.id);
            },
            child: const Text('Cancel Order', style: TextStyle(color: AppColors.errorRed)),
          ),
        ],
      ),
    );
  }
}
