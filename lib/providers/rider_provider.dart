import 'package:flutter/foundation.dart';
import '../models/rider_model.dart';
import '../services/api_service.dart';

class RiderProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<RiderModel> _riders = [];
  bool _isLoading = false;
  String? _error;

  List<RiderModel> get riders => _riders;
  bool get isLoading => _isLoading;

  Future<void> loadRiders() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _apiService.get('/riders');
      
      if (response['success']) {
        _riders = (response['riders'] as List)
            .map((json) => RiderModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading riders: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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

  Future<void> updateRiderAvailability(String riderId, bool isAvailable) async {
    try {
      final response = await _apiService.put('/riders/$riderId/availability', data: {
        'isAvailable': isAvailable,
      });
      
      if (response['success']) {
        final index = _riders.indexWhere((r) => r.id == riderId);
        if (index != -1) {
          _riders[index] = RiderModel.fromJson(response['rider']);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error updating rider availability: $e');
      rethrow;
    }
  }

  Future<void> loadAvailableRiders() async {
    try {
      final response = await _apiService.get('/riders/available');
      
      if (response['success']) {
        _riders = (response['riders'] as List)
            .map((json) => RiderModel.fromJson(json))
            .toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading available riders: $e');
      // Fallback to loading all riders
      await loadRiders();
    }
  }

  Future<List<RiderModel>> getNearbyRiders(double lat, double lng, {double radiusKm = 10}) async {
    try {
      final response = await _apiService.get('/riders/nearby', queryParams: {
        'lat': lat,
        'lng': lng,
        'radius': radiusKm,
      });
      
      if (response['success']) {
        return (response['riders'] as List)
            .map((json) => RiderModel.fromJson(json))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading nearby riders: $e');
    }
    return [];
  }
}
