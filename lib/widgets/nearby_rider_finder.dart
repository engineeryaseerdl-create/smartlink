import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/order_model.dart';
import '../models/rider_model.dart';
import '../providers/rider_provider.dart';
import '../providers/order_provider.dart';
import '../utils/constants.dart';

class NearbyRiderFinder extends StatefulWidget {
  final OrderModel order;

  const NearbyRiderFinder({super.key, required this.order});

  @override
  State<NearbyRiderFinder> createState() => _NearbyRiderFinderState();
}

class _NearbyRiderFinderState extends State<NearbyRiderFinder> {
  List<RiderModel> _nearbyRiders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _findNearbyRiders();
  }

  void _findNearbyRiders() async {
    setState(() => _isLoading = true);
    
    try {
      // Simulate finding nearby riders based on seller location
      final riderProvider = context.read<RiderProvider>();
      await riderProvider.loadAvailableRiders();
      
      // Filter riders by distance (mock implementation)
      final allRiders = riderProvider.getAvailableRiders();
      _nearbyRiders = allRiders.where((rider) {
        // Mock distance calculation - in real app, use GPS coordinates
        return _calculateDistance(widget.order.sellerLocation, rider.location) < 10;
      }).toList();
      
      // Sort by rating and distance
      _nearbyRiders.sort((a, b) => b.rating.compareTo(a.rating));
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error finding riders: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  double _calculateDistance(String location1, String location2) {
    // Mock distance calculation - return random distance between 1-15 km
    return (location1.hashCode % 15) + 1.0;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.location_searching, color: AppColors.primaryGreen),
              const SizedBox(width: 8),
              const Text('Nearby Riders', style: AppTextStyles.heading3),
              const Spacer(),
              IconButton(
                onPressed: _findNearbyRiders,
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (_isLoading)
            const Expanded(
              child: Center(child: CircularProgressIndicator()),
            )
          else if (_nearbyRiders.isEmpty)
            const Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search_off, size: 64, color: AppColors.textSecondary),
                    SizedBox(height: 16),
                    Text('No nearby riders found'),
                    SizedBox(height: 8),
                    Text('Try refreshing or check back later'),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _nearbyRiders.length,
                itemBuilder: (context, index) {
                  final rider = _nearbyRiders[index];
                  final distance = _calculateDistance(widget.order.sellerLocation, rider.location);
                  
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
                                border: Border.fromBorderSide(
                                  BorderSide(color: Colors.white, width: 2),
                                ),
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
                            '${distance.toStringAsFixed(1)}km away • ${rider.totalDeliveries} deliveries',
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
                            '₦${(distance * 50).toInt()}',
                            style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryGreen,
                            ),
                          ),
                          Text(
                            '${(distance * 3).toInt()} mins',
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      onTap: () => _assignRider(rider),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  void _assignRider(RiderModel rider) async {
    try {
      await context.read<OrderProvider>().assignRider(widget.order.id, rider.id);
      
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${rider.name} assigned to delivery'),
          backgroundColor: AppColors.successGreen,
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to assign rider: $e'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }
}