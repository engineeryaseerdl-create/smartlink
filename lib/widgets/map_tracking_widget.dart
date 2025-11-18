import 'package:flutter/material.dart';
import '../utils/constants.dart';

class MapTrackingWidget extends StatefulWidget {
  final Map<String, double>? riderLocation;
  final Map<String, double>? deliveryLocation;
  final Map<String, double>? pickupLocation;
  final String orderStatus;
  final Function(Map<String, double>)? onLocationUpdate;

  const MapTrackingWidget({
    super.key,
    this.riderLocation,
    this.deliveryLocation,
    this.pickupLocation,
    required this.orderStatus,
    this.onLocationUpdate,
  });

  @override
  State<MapTrackingWidget> createState() => _MapTrackingWidgetState();
}

class _MapTrackingWidgetState extends State<MapTrackingWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Placeholder map (replace with actual map implementation)
            Container(
              width: double.infinity,
              height: double.infinity,
              color: AppColors.backgroundLight,
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map, size: 64, color: AppColors.textSecondary),
                    SizedBox(height: AppSpacing.sm),
                    Text('Map View', style: AppTextStyles.bodyLarge),
                    Text('(Google Maps integration needed)', style: AppTextStyles.bodySmall),
                  ],
                ),
              ),
            ),
            
            // Status overlay
            Positioned(
              top: AppSpacing.md,
              left: AppSpacing.md,
              right: AppSpacing.md,
              child: Container(
                padding: const EdgeInsets.all(AppSpacing.sm),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 12,
                      height: 12,
                      decoration: BoxDecoration(
                        color: _getStatusColor(widget.orderStatus),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Text(
                      _getStatusText(widget.orderStatus),
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            // Location info
            if (widget.riderLocation != null)
              Positioned(
                bottom: AppSpacing.md,
                left: AppSpacing.md,
                right: AppSpacing.md,
                child: Container(
                  padding: const EdgeInsets.all(AppSpacing.sm),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, color: AppColors.primaryGreen),
                      const SizedBox(width: AppSpacing.sm),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Rider Location', style: AppTextStyles.bodySmall),
                            Text(
                              'Lat: ${widget.riderLocation!['latitude']?.toStringAsFixed(4)}, '
                              'Lng: ${widget.riderLocation!['longitude']?.toStringAsFixed(4)}',
                              style: AppTextStyles.caption,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'preparing':
        return Colors.purple;
      case 'ready':
        return Colors.cyan;
      case 'assigned':
        return Colors.indigo;
      case 'picked_up':
        return Colors.amber;
      case 'in_transit':
        return AppColors.primaryGreen;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return AppColors.textSecondary;
    }
  }

  String _getStatusText(String status) {
    switch (status) {
      case 'pending':
        return 'Order Pending';
      case 'confirmed':
        return 'Order Confirmed';
      case 'preparing':
        return 'Being Prepared';
      case 'ready':
        return 'Ready for Pickup';
      case 'assigned':
        return 'Rider Assigned';
      case 'picked_up':
        return 'Order Picked Up';
      case 'in_transit':
        return 'On the Way';
      case 'delivered':
        return 'Delivered';
      case 'cancelled':
        return 'Cancelled';
      default:
        return status.toUpperCase();
    }
  }
}

class LocationPickerWidget extends StatefulWidget {
  final Map<String, double>? initialLocation;
  final Function(Map<String, double>) onLocationSelected;
  final String title;

  const LocationPickerWidget({
    super.key,
    this.initialLocation,
    required this.onLocationSelected,
    this.title = 'Select Location',
  });

  @override
  State<LocationPickerWidget> createState() => _LocationPickerWidgetState();
}

class _LocationPickerWidgetState extends State<LocationPickerWidget> {
  Map<String, double>? _selectedLocation;

  @override
  void initState() {
    super.initState();
    _selectedLocation = widget.initialLocation;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.title, style: AppTextStyles.bodyLarge),
        const SizedBox(height: AppSpacing.sm),
        GestureDetector(
          onTap: _showLocationPicker,
          child: Container(
            height: 200,
            width: double.infinity,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.borderLight),
              borderRadius: BorderRadius.circular(8),
              color: AppColors.backgroundLight,
            ),
            child: _selectedLocation != null
                ? Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: double.infinity,
                        color: AppColors.backgroundLight,
                        child: const Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.location_on, size: 32, color: AppColors.primaryGreen),
                              SizedBox(height: AppSpacing.sm),
                              Text('Location Selected', style: AppTextStyles.bodyMedium),
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: AppSpacing.sm,
                        left: AppSpacing.sm,
                        right: AppSpacing.sm,
                        child: Container(
                          padding: const EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Lat: ${_selectedLocation!['latitude']?.toStringAsFixed(4)}, '
                            'Lng: ${_selectedLocation!['longitude']?.toStringAsFixed(4)}',
                            style: AppTextStyles.caption,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    ],
                  )
                : const Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.add_location, size: 32, color: AppColors.textSecondary),
                      SizedBox(height: AppSpacing.sm),
                      Text('Tap to select location', style: AppTextStyles.bodyMedium),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  void _showLocationPicker() {
    // In a real app, you would show a map picker here
    // For now, we'll simulate location selection
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(widget.title),
        content: const Text('In a real app, this would open a map to select location.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              // Simulate location selection
              final location = {
                'latitude': 6.5244 + (DateTime.now().millisecond / 100000),
                'longitude': 3.3792 + (DateTime.now().millisecond / 100000),
              };
              setState(() {
                _selectedLocation = location;
              });
              widget.onLocationSelected(location);
              Navigator.pop(context);
            },
            child: const Text('Select Current Location'),
          ),
        ],
      ),
    );
  }
}

class DeliveryFeeWidget extends StatelessWidget {
  final double distance;
  final double deliveryFee;
  final int estimatedTime;

  const DeliveryFeeWidget({
    super.key,
    required this.distance,
    required this.deliveryFee,
    required this.estimatedTime,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Delivery Information', style: AppTextStyles.bodyLarge),
          const SizedBox(height: AppSpacing.sm),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Distance:', style: AppTextStyles.bodyMedium),
              Text('${distance.toStringAsFixed(1)} km', style: AppTextStyles.bodyMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Estimated Time:', style: AppTextStyles.bodyMedium),
              Text('$estimatedTime mins', style: AppTextStyles.bodyMedium),
            ],
          ),
          const SizedBox(height: AppSpacing.xs),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Delivery Fee:', style: AppTextStyles.bodyMedium),
              Text(
                '₦${deliveryFee.toStringAsFixed(0)}',
                style: AppTextStyles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryGreen,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}