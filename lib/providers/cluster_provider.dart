import 'package:flutter/foundation.dart';
import '../models/rider_cluster_model.dart';
import '../models/rider_model.dart';
import '../services/api_service.dart';

class ClusterProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<RiderCluster> _clusters = [];
  bool _isLoading = false;
  String? _error;

  List<RiderCluster> get clusters => _clusters;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadClusters({String? location, String? serviceArea, bool? isOnline}) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final queryParams = <String, dynamic>{};
      if (location != null) queryParams['location'] = location;
      if (serviceArea != null) queryParams['serviceArea'] = serviceArea;
      if (isOnline != null) queryParams['isOnline'] = isOnline.toString();

      final response = await _apiService.get('/clusters', queryParams: queryParams);

      if (response['success']) {
        _clusters = (response['clusters'] as List)
            .map((json) => RiderCluster.fromJson(json))
            .toList();
      }
    } catch (e) {
      _error = e.toString();
      debugPrint('Error loading clusters: $e');
      
      // Fallback to mock data for demo
      _clusters = [
      RiderCluster(
        id: 'cluster_1',
        name: 'Kano Central Riders',
        location: 'Sabon Gari, Kano',
        leaderName: 'Musa Ibrahim',
        leaderPhone: '08012345678',
        backupPhone: '08087654321',
        members: [
          ClusterMember(
            id: 'rider_1',
            name: 'Musa Ibrahim',
            phone: '08012345678',
            vehicleType: VehicleType.okada,
            vehiclePlate: 'KN-123-ABC',
            isLeader: true,
            joinedAt: DateTime.now().subtract(const Duration(days: 30)),
          ),
          ClusterMember(
            id: 'rider_2',
            name: 'Aliyu Hassan',
            phone: '08087654321',
            vehicleType: VehicleType.okada,
            vehiclePlate: 'KN-456-DEF',
            joinedAt: DateTime.now().subtract(const Duration(days: 25)),
          ),
        ],
        isOnline: true,
        rating: 4.8,
        totalDeliveries: 245,
        serviceAreas: ['Sabon Gari', 'Fagge', 'Nassarawa'],
        createdAt: DateTime.now().subtract(const Duration(days: 60)),
      ),
      RiderCluster(
        id: 'cluster_2',
        name: 'Lagos Island Express',
        location: 'Victoria Island, Lagos',
        leaderName: 'Emeka Okafor',
        leaderPhone: '08098765432',
        members: [
          ClusterMember(
            id: 'rider_3',
            name: 'Emeka Okafor',
            phone: '08098765432',
            vehicleType: VehicleType.okada,
            vehiclePlate: 'LA-789-GHI',
            isLeader: true,
            joinedAt: DateTime.now().subtract(const Duration(days: 45)),
          ),
        ],
        isOnline: false,
        rating: 4.6,
        totalDeliveries: 189,
        serviceAreas: ['Victoria Island', 'Ikoyi', 'Lekki'],
        createdAt: DateTime.now().subtract(const Duration(days: 90)),
      ),
    ];

    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<RiderCluster?> createCluster({
    required String name,
    required Map<String, dynamic> location,
    required List<String> serviceAreas,
    List<String>? vehicleTypes,
    String? operatingHours,
    String? backupContactId,
  }) async {
    try {
      final response = await _apiService.post('/clusters', data: {
        'name': name,
        'location': location,
        'serviceAreas': serviceAreas,
        if (vehicleTypes != null) 'vehicleTypes': vehicleTypes,
        if (operatingHours != null) 'operatingHours': operatingHours,
        if (backupContactId != null) 'backupContactId': backupContactId,
      });

      if (response['success']) {
        final cluster = RiderCluster.fromJson(response['cluster']);
        _clusters.insert(0, cluster);
        notifyListeners();
        return cluster;
      }
    } catch (e) {
      debugPrint('Error creating cluster: $e');
    }
    return null;
  }

  Future<bool> updateCluster(String clusterId, Map<String, dynamic> updates) async {
    try {
      final response = await _apiService.put('/clusters/$clusterId', data: updates);

      if (response['success']) {
        final updatedCluster = RiderCluster.fromJson(response['cluster']);
        final index = _clusters.indexWhere((c) => c.id == clusterId);
        if (index != -1) {
          _clusters[index] = updatedCluster;
          notifyListeners();
        }
        return true;
      }
    } catch (e) {
      debugPrint('Error updating cluster: $e');
    }
    return false;
  }

  Future<bool> assignOrderToCluster(String clusterId, String orderId, {String? specificRiderId}) async {
    try {
      final response = await _apiService.post('/clusters/$clusterId/assign-order', data: {
        'orderId': orderId,
        if (specificRiderId != null) 'specificRiderId': specificRiderId,
      });

      if (response['success']) {
        // Update cluster stats
        await loadClusters();
        return true;
      }
    } catch (e) {
      debugPrint('Error assigning order to cluster: $e');
    }
    return false;
  }

  Future<Map<String, dynamic>?> getClusterStats(String clusterId) async {
    try {
      final response = await _apiService.get('/clusters/$clusterId/stats');

      if (response['success']) {
        return response['stats'];
      }
    } catch (e) {
      debugPrint('Error getting cluster stats: $e');
    }
    return null;
  }

  List<RiderCluster> getClustersForLocation(String location) {
    return _clusters.where((cluster) => 
      cluster.serviceAreas.any((area) => 
        area.toLowerCase().contains(location.toLowerCase())
      )
    ).toList();
  }

  RiderCluster? getClusterById(String id) {
    try {
      return _clusters.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  RiderCluster? getClusterByRiderId(String riderId) {
    for (final cluster in _clusters) {
      if (cluster.members.any((member) => member.id == riderId)) {
        return cluster;
      }
    }
    return null;
  }

  void updateClusterStatus(String clusterId, bool isOnline) {
    final index = _clusters.indexWhere((c) => c.id == clusterId);
    if (index != -1) {
      final cluster = _clusters[index];
      _clusters[index] = RiderCluster(
        id: cluster.id,
        name: cluster.name,
        location: cluster.location,
        leaderName: cluster.leaderName,
        leaderPhone: cluster.leaderPhone,
        backupPhone: cluster.backupPhone,
        members: cluster.members,
        isOnline: isOnline,
        rating: cluster.rating,
        totalDeliveries: cluster.totalDeliveries,
        operatingHours: cluster.operatingHours,
        serviceAreas: cluster.serviceAreas,
        vehicleTypes: cluster.vehicleTypes,
        createdAt: cluster.createdAt,
      );
      notifyListeners();
    }
  }
}