import 'package:flutter/material.dart';
import '../models/order_model.dart';
import '../utils/constants.dart';

class OrderStatusBanner extends StatelessWidget {
  final List<OrderModel> orders;

  const OrderStatusBanner({super.key, required this.orders});

  @override
  Widget build(BuildContext context) {
    final pendingOrders = orders.where((o) => o.riderId == null && o.status != OrderStatus.cancelled).toList();
    final assignedOrders = orders.where((o) => o.riderId != null && o.status != OrderStatus.delivered).toList();

    if (pendingOrders.isEmpty && assignedOrders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          if (pendingOrders.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.warningOrange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.warningOrange.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.hourglass_empty, color: AppColors.warningOrange),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${pendingOrders.length} order(s) waiting for rider',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.warningOrange,
                          ),
                        ),
                        const Text(
                          'Sellers are finding the best riders for delivery',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          
          if (pendingOrders.isNotEmpty && assignedOrders.isNotEmpty)
            const SizedBox(height: 12),
          
          if (assignedOrders.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.successGreen.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: AppColors.successGreen.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.delivery_dining, color: AppColors.successGreen),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${assignedOrders.length} order(s) with assigned riders',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.successGreen,
                          ),
                        ),
                        const Text(
                          'Tap on orders to view rider details',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
