import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../utils/constants.dart';

class OrderTrackingWidget extends StatelessWidget {
  final OrderModel order;

  const OrderTrackingWidget({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ORDER ID + STATUS BADGE
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${_safeId(order.id)}',
                style: AppTextStyles.heading3.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: _getStatusColor(order.status).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  _getStatusText(order.status),
                  style: AppTextStyles.bodySmall.copyWith(
                    color: _getStatusColor(order.status),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppSpacing.lg),

          /// TIMELINE
          _buildTrackingTimeline(),

          const SizedBox(height: AppSpacing.lg),

          /// RIDER INFO (IF AVAILABLE)
          if (order.riderId != null && order.riderId!.isNotEmpty) 
            _buildRiderInfo(),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------------------------------
  // TIMELINE
  // -----------------------------------------------------------------------------------------

  Widget _buildTrackingTimeline() {
    final steps = [
      TrackingStep(
        title: 'Order Placed',
        subtitle: 'Your order has been confirmed',
        isCompleted: true,
        timestamp: order.createdAt,
      ),
      TrackingStep(
        title: 'Processing',
        subtitle: 'Seller is preparing your order',
        isCompleted: order.status != OrderStatus.pending,
        timestamp: order.status != OrderStatus.pending 
            ? order.createdAt.add(const Duration(minutes: 30)) 
            : null,
      ),
      TrackingStep(
        title: 'Out for Delivery',
        subtitle: 'Rider is on the way',
        isCompleted: order.status == OrderStatus.delivered ||
            order.status == OrderStatus.inTransit,
        timestamp: order.status == OrderStatus.delivered ||
                order.status == OrderStatus.inTransit
            ? order.createdAt.add(const Duration(hours: 2))
            : null,
      ),
      TrackingStep(
        title: 'Delivered',
        subtitle: 'Order delivered successfully',
        isCompleted: order.status == OrderStatus.delivered,
        timestamp: order.status == OrderStatus.delivered 
            ? order.updatedAt 
            : null,
      ),
    ];

    return Column(
      children: steps.asMap().entries.map((entry) {
        final index = entry.key;
        final step = entry.value;
        final isLast = index == steps.length - 1;

        return Padding(
          padding: EdgeInsets.only(bottom: isLast ? 0 : AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Timeline circles + vertical line
              Column(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: step.isCompleted
                          ? AppColors.primaryGreen
                          : AppColors.backgroundLight,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: step.isCompleted
                            ? AppColors.primaryGreen
                            : AppColors.textSecondary,
                        width: 2,
                      ),
                    ),
                    child: step.isCompleted
                        ? const Icon(Icons.check, color: Colors.white, size: 16)
                        : null,
                  ),
                  if (!isLast)
                    Container(
                      width: 2,
                      height: 40,
                      color: step.isCompleted
                          ? AppColors.primaryGreen
                          : AppColors.backgroundLight,
                    ),
                ],
              ),

              const SizedBox(width: AppSpacing.md),

              /// Timeline text
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      step.title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w600,
                        color: step.isCompleted
                            ? AppColors.textPrimary
                            : AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      step.subtitle,
                      style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                    if (step.timestamp != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        _formatTimestamp(step.timestamp!),
                        style: AppTextStyles.bodySmall.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // -----------------------------------------------------------------------------------------
  // RIDER INFO BOX
  // -----------------------------------------------------------------------------------------

  Widget _buildRiderInfo() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(AppBorderRadius.md),
      ),
      child: Row(
        children: [
          /// Icon circle
          Container(
            width: 50,
            height: 50,
            decoration: const BoxDecoration(
              color: AppColors.primaryGreen,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.delivery_dining,
              color: Colors.white,
              size: 24,
            ),
          ),

          const SizedBox(width: AppSpacing.md),

          /// Texts
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Rider',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Rider #${_safeId(order.riderId)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),

          /// Phone button
          InkWell(
            onTap: () {
              // TODO: Call rider
              debugPrint('Call rider: ${order.riderId}');
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(
                color: AppColors.primaryGreen,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.phone,
                color: Colors.white,
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // -----------------------------------------------------------------------------------------
  // HELPERS
  // -----------------------------------------------------------------------------------------

  String _safeId(String? id) {
    if (id == null || id.isEmpty) return "N/A";
    return id.length >= 8 ? id.substring(0, 8) : id;
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return AppColors.warningOrange;
      case OrderStatus.confirmed:
        return AppColors.infoBlue;
      case OrderStatus.inTransit:
        return AppColors.primaryGreen;
      case OrderStatus.delivered:
        return AppColors.successGreen;
      case OrderStatus.cancelled:
        return AppColors.errorRed;
    }
  }

  String _getStatusText(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
      case OrderStatus.inTransit:
        return 'In Transit';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inDays > 0) {
      return '${difference.inDays}d ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}h ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}m ago';
    } else if (difference.inSeconds > 0) {
      return 'Just now';
    } else {
      // Handle future dates
      return 'Just now';
    }
  }
}

// -----------------------------------------------------------------------------------------
// TRACKING STEP MODEL
// -----------------------------------------------------------------------------------------

class TrackingStep {
  final String title;
  final String subtitle;
  final bool isCompleted;
  final DateTime? timestamp;

  TrackingStep({
    required this.title,
    required this.subtitle,
    required this.isCompleted,
    this.timestamp,
  });
}