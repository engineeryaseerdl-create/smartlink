import 'package:flutter/material.dart';
import '../models/rider_model.dart';
import '../utils/constants.dart';

class OkadaAssignmentSheet extends StatelessWidget {
  final List<RiderModel> availableRiders;
  final Function(RiderModel) onRiderSelected;

  const OkadaAssignmentSheet({
    super.key,
    required this.availableRiders,
    required this.onRiderSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.motorcycle, color: AppColors.primaryGreen),
              const SizedBox(width: 8),
              const Text('Available Okada Riders', style: AppTextStyles.heading3),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: availableRiders.length,
              itemBuilder: (context, index) {
                final rider = availableRiders[index];
                return _buildRiderCard(rider);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRiderCard(RiderModel rider) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Stack(
          children: [
            CircleAvatar(
              backgroundColor: AppColors.primaryGreen,
              child: Text(
                rider.name.isNotEmpty ? rider.name[0] : '?',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                width: 12,
                height: 12,
                decoration: const BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ],
        ),
        title: Text(rider.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.motorcycle, size: 14),
                const SizedBox(width: 4),
                Text(rider.vehiclePlate),
                const SizedBox(width: 8),
                const Icon(Icons.star, size: 14, color: AppColors.gold),
                Text(' ${rider.rating}'),
              ],
            ),
            Text(
              '${rider.totalDeliveries} deliveries • 2.5km away',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '₦200',
              style: AppTextStyles.bodyMedium.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.primaryGreen,
              ),
            ),
            Text(
              '15 mins',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        onTap: () => onRiderSelected(rider),
      ),
    );
  }
}