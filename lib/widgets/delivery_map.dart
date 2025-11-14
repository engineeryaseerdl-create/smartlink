import 'package:flutter/material.dart';
import '../utils/constants.dart';

class DeliveryTrackingWidget extends StatefulWidget {
  final String orderId;
  final String riderName;
  final String estimatedTime;

  const DeliveryTrackingWidget({
    super.key,
    required this.orderId,
    required this.riderName,
    required this.estimatedTime,
  });

  @override
  State<DeliveryTrackingWidget> createState() => _DeliveryTrackingWidgetState();
}

class _DeliveryTrackingWidgetState extends State<DeliveryTrackingWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      decoration: BoxDecoration(
        color: AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      ),
      child: Stack(
        children: [
          // Mock map background
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              image: const DecorationImage(
                image: NetworkImage('https://via.placeholder.com/400x300/E8F5E9/00A86B?text=MAP'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Animated rider marker
          Positioned(
            top: 120,
            left: 150,
            child: AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryGreen.withOpacity(0.3),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.delivery_dining, color: Colors.white),
                  ),
                );
              },
            ),
          ),
          // Delivery info overlay
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(AppBorderRadius.lg),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primaryGreen,
                    child: Text(
                      widget.riderName[0],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.riderName,
                          style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'ETA: ${widget.estimatedTime}',
                          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => _callRider(),
                    icon: const Icon(Icons.phone, color: AppColors.primaryGreen),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _callRider() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Call Rider'),
        content: Text('Call ${widget.riderName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Call'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class LocationPickerWidget extends StatelessWidget {
  final Function(String) onLocationSelected;

  const LocationPickerWidget({super.key, required this.onLocationSelected});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        children: [
          Text('Select Delivery Location', style: AppTextStyles.heading3),
          const SizedBox(height: AppSpacing.lg),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppColors.backgroundLight,
                borderRadius: BorderRadius.circular(AppBorderRadius.lg),
              ),
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.location_on, size: 60, color: AppColors.primaryGreen),
                    SizedBox(height: AppSpacing.md),
                    Text('Interactive Map Coming Soon'),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildLocationOption('Current Location', Icons.my_location),
          _buildLocationOption('Home', Icons.home),
          _buildLocationOption('Work', Icons.work),
          _buildLocationOption('Other', Icons.add_location),
        ],
      ),
    );
  }

  Widget _buildLocationOption(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: AppColors.primaryGreen),
      title: Text(title),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () => onLocationSelected(title),
    );
  }
}