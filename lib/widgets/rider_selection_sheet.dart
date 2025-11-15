import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order_model.dart';
import '../models/rider_model.dart';
import '../providers/rider_provider.dart';
import '../providers/order_provider.dart';
import '../utils/constants.dart';

class RiderSelectionBottomSheet extends StatefulWidget {
  final OrderModel order;

  const RiderSelectionBottomSheet({
    super.key,
    required this.order,
  });

  @override
  State<RiderSelectionBottomSheet> createState() => _RiderSelectionBottomSheetState();
}

class _RiderSelectionBottomSheetState extends State<RiderSelectionBottomSheet> {
  String? _selectedRiderId;
  bool _isAssigning = false;

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<RiderProvider>().loadAvailableRiders();
    });
  }

  Future<void> _assignRider() async {
    if (_selectedRiderId == null) return;

    setState(() {
      _isAssigning = true;
    });

    try {
      await context.read<OrderProvider>().assignRider(widget.order.id, _selectedRiderId!);
      
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Rider assigned successfully!'),
            backgroundColor: AppColors.successGreen,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to assign rider: $e'),
            backgroundColor: AppColors.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isAssigning = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Icon(Icons.delivery_dining, color: AppColors.primaryGreen),
                const SizedBox(width: 8),
                Text(
                  'Select Rider for Order #${widget.order.id.substring(0, 8)}',
                  style: AppTextStyles.heading3.copyWith(fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: Consumer<RiderProvider>(
              builder: (context, riderProvider, child) {
                if (riderProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final availableRiders = riderProvider.riders
                    .where((rider) => rider.isAvailable)
                    .toList();

                if (availableRiders.isEmpty) {
                  return const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.delivery_dining_outlined, size: 80, color: Colors.grey),
                        SizedBox(height: 16),
                        Text('No Available Riders', style: AppTextStyles.heading3),
                        Text('Please try again later'),
                      ],
                    ),
                  );
                }

                return ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: availableRiders.length,
                  itemBuilder: (context, index) {
                    final rider = availableRiders[index];
                    final isSelected = _selectedRiderId == rider.id;

                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? AppColors.primaryGreen : Colors.grey[300]!,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ListTile(
                        contentPadding: const EdgeInsets.all(12),
                        leading: Stack(
                          children: [
                            CircleAvatar(
                              radius: 25,
                              backgroundColor: AppColors.primaryGreen,
                              backgroundImage: rider.profileImage != null
                                  ? NetworkImage(rider.profileImage!)
                                  : null,
                              child: rider.profileImage == null
                                  ? Text(rider.name[0], style: const TextStyle(color: Colors.white))
                                  : null,
                            ),
                            if (rider.isVerified)
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(2),
                                  decoration: const BoxDecoration(
                                    color: AppColors.successGreen,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(Icons.check, color: Colors.white, size: 10),
                                ),
                              ),
                          ],
                        ),
                        title: Row(
                          children: [
                            Expanded(child: Text(rider.name, style: AppTextStyles.bodyLarge.copyWith(fontWeight: FontWeight.bold))),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                              decoration: BoxDecoration(
                                color: rider.vehicleType == VehicleType.car
                                    ? AppColors.infoBlue.withOpacity(0.1)
                                    : AppColors.warningOrange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                rider.vehicleType.toString().split('.').last.toUpperCase(),
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                  color: rider.vehicleType == VehicleType.car
                                      ? AppColors.infoBlue
                                      : AppColors.warningOrange,
                                ),
                              ),
                            ),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(Icons.star, size: 14, color: AppColors.gold),
                                const SizedBox(width: 4),
                                Text('${rider.rating} (${rider.totalDeliveries} deliveries)'),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text('📍 ${rider.location}', style: AppTextStyles.bodySmall),
                            Text('🚗 ${rider.vehiclePlate}', style: AppTextStyles.bodySmall),
                          ],
                        ),
                        trailing: Radio<String>(
                          value: rider.id,
                          groupValue: _selectedRiderId,
                          onChanged: (value) {
                            setState(() {
                              _selectedRiderId = value;
                            });
                          },
                          activeColor: AppColors.primaryGreen,
                        ),
                        onTap: () {
                          setState(() {
                            _selectedRiderId = rider.id;
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: _selectedRiderId != null && !_isAssigning ? _assignRider : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                minimumSize: const Size(double.infinity, 48),
              ),
              child: _isAssigning
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2, valueColor: AlwaysStoppedAnimation<Color>(Colors.white)),
                    )
                  : const Text('Assign Rider'),
            ),
          ),
        ],
      ),
    );
  }
}