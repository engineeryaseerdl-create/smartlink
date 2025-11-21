import 'package:flutter/material.dart';
import '../utils/constants.dart';

class OkadaSafetyWidget extends StatelessWidget {
  final String riderName;
  final String plateNumber;

  const OkadaSafetyWidget({
    super.key,
    required this.riderName,
    required this.plateNumber,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.primaryGreen.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security, color: AppColors.primaryGreen, size: 16),
              const SizedBox(width: 6),
              Text(
                'Safety Information',
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildSafetyItem('Verified Rider', riderName),
          _buildSafetyItem('Plate Number', plateNumber),
          _buildSafetyItem('Insurance', 'Covered'),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _shareRideDetails(),
                  icon: const Icon(Icons.share, size: 16),
                  label: const Text('Share Ride'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ElevatedButton.icon(
                onPressed: () => _emergencyCall(),
                icon: const Icon(Icons.emergency, size: 16),
                label: const Text('SOS'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(vertical: 8),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSafetyItem(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          Text(
            value,
            style: AppTextStyles.bodySmall.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  void _shareRideDetails() {
    // Share rider details with emergency contacts
  }

  void _emergencyCall() {
    // Call emergency services
  }
}
