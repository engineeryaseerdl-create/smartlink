import 'package:flutter/foundation.dart';
import '../models/rider_model.dart';
import '../services/mock_data_service.dart';

class RiderProvider with ChangeNotifier {
  List<RiderModel> _riders = [];
  bool _isLoading = false;

  List<RiderModel> get riders => _riders;
  bool get isLoading => _isLoading;

  Future<void> loadRiders() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    _riders = await MockDataService.loadRiders();

    _isLoading = false;
    notifyListeners();
  }

  List<RiderModel> getAvailableRiders({VehicleType? vehicleType}) {
    return _riders.where((rider) {
      final isAvailable = rider.isAvailable;
      final matchesType =
          vehicleType == null || rider.vehicleType == vehicleType;
      return isAvailable && matchesType;
    }).toList();
  }

  List<RiderModel> getRidersByLocation(String location) {
    return _riders
        .where((rider) =>
            rider.location.toLowerCase().contains(location.toLowerCase()))
        .toList();
  }

  RiderModel? getRiderById(String id) {
    try {
      return _riders.firstWhere((r) => r.id == id);
    } catch (e) {
      return null;
    }
  }

  void updateRiderAvailability(String riderId, bool isAvailable) {
    final index = _riders.indexWhere((r) => r.id == riderId);
    if (index != -1) {
      final rider = _riders[index];
      _riders[index] = RiderModel(
        id: rider.id,
        name: rider.name,
        phone: rider.phone,
        email: rider.email,
        vehicleType: rider.vehicleType,
        vehiclePlate: rider.vehiclePlate,
        location: rider.location,
        profileImage: rider.profileImage,
        rating: rider.rating,
        totalDeliveries: rider.totalDeliveries,
        isAvailable: isAvailable,
        isVerified: rider.isVerified,
        currentLat: rider.currentLat,
        currentLng: rider.currentLng,
      );
      notifyListeners();
    }
  }

  Future<void> loadAvailableRiders() async {
    if (_riders.isEmpty) {
      await loadRiders();
    }
  }
}
