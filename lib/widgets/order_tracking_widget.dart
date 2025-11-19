import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../utils/constants.dart';
import 'animated_widgets.dart';

class OrderTrackingWidget extends StatelessWidget {
  final OrderModel order;
  final bool showFullHistory;

  const OrderTrackingWidget({
    super.key,
    required this.order,
    this.showFullHistory = false,
  });

  @override
  Widget build(BuildContext context) {
    final trackingSteps = _getTrackingSteps();
    final currentStepIndex = _getCurrentStepIndex();

    return Container(
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.local_shipping,
                color: AppColors.primaryGreen,
                size: ResponsiveUtils.isDesktop(context) ? 28 : 24,
              ),
              const SizedBox(width: AppSpacing.sm),
              Text(
                'Order Tracking',
                style: ResponsiveUtils.isDesktop(context)
                  ? AppTextStyles.heading2
                  : AppTextStyles.heading3,
              ),
              const Spacer(),
              if (order.trackingCode != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppBorderRadius.sm),
                  ),
                  child: Text(
                    '#${order.trackingCode}',
                    style: AppTextStyles.bodySmall.copyWith(
                      color: AppColors.primaryGreen,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
          SizedBox(height: ResponsiveUtils.isDesktop(context) 
            ? AppSpacing.lg : AppSpacing.md),
          
          // Tracking Timeline
          _buildTrackingTimeline(trackingSteps, currentStepIndex),
          
          if (showFullHistory && order.trackingHistory.isNotEmpty) ...[
            SizedBox(height: ResponsiveUtils.isDesktop(context) 
              ? AppSpacing.lg : AppSpacing.md),
            const Divider(),
            SizedBox(height: ResponsiveUtils.isDesktop(context) 
              ? AppSpacing.lg : AppSpacing.md),
            Text(
              'Detailed History',
              style: ResponsiveUtils.isDesktop(context)
                ? AppTextStyles.heading3
                : AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.md),
            _buildDetailedHistory(),
          ],
        ],
      ),
    );
  }

  Widget _buildTrackingTimeline(List<TrackingStep> steps, int currentStep) {
    return Column(
      children: steps.asMap().entries.map((entry) {
        int index = entry.key;
        TrackingStep step = entry.value;
        bool isCompleted = index <= currentStep;
        bool isCurrent = index == currentStep;
        bool isLast = index == steps.length - 1;

        return FadeInWidget(
          delay: Duration(milliseconds: index * 100),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  ScaleInWidget(
                    delay: Duration(milliseconds: index * 150),
                    child: Container(
                      width: 24,
                      height: 24,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: isCompleted 
                          ? AppColors.primaryGreen 
                          : AppColors.lightGrey,
                        border: isCurrent
                          ? Border.all(
                              color: AppColors.primaryGreen,
                              width: 3,
                            )
                          : null,
                      ),
                      child: isCompleted
                        ? const Icon(
                            Icons.check,
                            color: AppColors.white,
                            size: 16,
                          )
                        : null,
                    ),
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 40,
                      color: isCompleted 
                        ? AppColors.primaryGreen 
                        : AppColors.lightGrey,
                    ),
                ],
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: isCompleted 
                          ? FontWeight.w600 
                          : FontWeight.normal,
                        color: isCompleted 
                          ? AppColors.darkGrey 
                          : AppColors.grey,
                      ),
                    ),
                    if (step.description != null)
                      Text(
                        step.description!,
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                    if (step.timestamp != null && isCompleted)
                      Text(
                        _formatTimestamp(step.timestamp!),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  Widget _buildDetailedHistory() {
    return Column(
      children: order.trackingHistory.reversed.map((tracking) {
        return FadeInWidget(
          slideUp: true,
          child: Container(
            margin: const EdgeInsets.only(bottom: AppSpacing.md),
            padding: const EdgeInsets.all(AppSpacing.md),
            decoration: BoxDecoration(
              color: AppColors.lightGrey,
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: _getStatusColor(tracking.status),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _getStatusIcon(tracking.status),
                    color: AppColors.white,
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        tracking.description,
                        style: AppTextStyles.bodyMedium.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _formatTimestamp(tracking.timestamp),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.grey,
                        ),
                      ),
                      if (tracking.location != null)
                        Text(
                          'Location: ${tracking.location}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                      if (tracking.riderNote != null)
                        Text(
                          'Note: ${tracking.riderNote}',
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.infoBlue,
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  List<TrackingStep> _getTrackingSteps() {
    return [
      TrackingStep(
        title: 'Order Placed',
        description: 'Your order has been placed successfully',
        timestamp: order.createdAt,
      ),
      TrackingStep(
        title: 'Order Confirmed',
        description: 'Seller has confirmed your order',
        timestamp: order.status.index >= 1 ? order.createdAt : null,
      ),
      TrackingStep(
        title: 'Pickup Ready',
        description: 'Order is ready for pickup',
        timestamp: order.status.index >= 2 ? order.createdAt : null,
      ),
      TrackingStep(
        title: 'In Transit',
        description: 'Your order is on the way',
        timestamp: order.status.index >= 3 ? order.createdAt : null,
      ),
      TrackingStep(
        title: 'Delivered',
        description: 'Order delivered successfully',
        timestamp: order.deliveredAt,
      ),
    ];
  }

  int _getCurrentStepIndex() {
    switch (order.status) {
      case OrderStatus.pending:
        return 0;
      case OrderStatus.confirmed:
        return 1;
      case OrderStatus.pickupReady:
        return 2;
      case OrderStatus.inTransit:
        return 3;
      case OrderStatus.delivered:
        return 4;
      case OrderStatus.cancelled:
        return -1; // Special case for cancelled orders
      case OrderStatus.modification_requested:
        return 0; // Back to pending state
    }
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.warningOrange;
      case OrderStatus.confirmed:
        return AppColors.infoBlue;
      case OrderStatus.pickupReady:
        return AppColors.primaryGreen;
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

  IconData _getStatusIcon(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Icons.schedule;
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

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays} days ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} hours ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} minutes ago';
    } else {
      return 'Just now';
    }
  }
}

class TrackingStep {
  final String title;
  final String? description;
  final DateTime? timestamp;

  TrackingStep({
    required this.title,
    this.description,
    this.timestamp,
  });
}