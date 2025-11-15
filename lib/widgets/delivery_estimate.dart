import 'package:flutter/material.dart';
import '../utils/constants.dart';

class DeliveryEstimate extends StatelessWidget {
  final String sellerLocation;
  final String buyerLocation;

  const DeliveryEstimate({
    super.key,
    required this.sellerLocation,
    required this.buyerLocation,
  });

  @override
  Widget build(BuildContext context) {
    final estimatedTime = _calculateDeliveryTime();
    final deliveryFee = _calculateDeliveryFee();

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: AppColors.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Icon(
              Icons.local_shipping,
              color: AppColors.primaryGreen,
              size: 16,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivers in $estimatedTime',
                  style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryGreen,
                  ),
                ),
                Text(
                  'to $buyerLocation',
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
          Text(
            deliveryFee == 0 ? 'FREE' : '₦${deliveryFee.toStringAsFixed(0)}',
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.bold,
              color: deliveryFee == 0 ? AppColors.successGreen : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  String _calculateDeliveryTime() {
    // Simple logic based on location similarity
    if (sellerLocation.toLowerCase().contains(buyerLocation.toLowerCase()) ||
        buyerLocation.toLowerCase().contains(sellerLocation.toLowerCase())) {
      return '30-45 mins';
    } else {
      return '1-2 hours';
    }
  }

  double _calculateDeliveryFee() {
    // Simple logic for delivery fee
    if (sellerLocation.toLowerCase().contains(buyerLocation.toLowerCase()) ||
        buyerLocation.toLowerCase().contains(sellerLocation.toLowerCase())) {
      return 0; // Free delivery within same area
    } else {
      return 500; // ₦500 for different areas
    }
  }
}