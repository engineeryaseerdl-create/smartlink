import 'package:flutter/foundation.dart';
import '../models/rider_cluster_model.dart';
import '../models/rider_model.dart';

class ClusterProvider with ChangeNotifier {
  List<RiderCluster> _clusters = [];
  bool _isLoading = false;

  List<RiderCluster> get clusters => _clusters;
  bool get isLoading => _isLoading;

  Future<void> loadClusters() async {
    _isLoading = true;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock data - replace with API call
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

    _isLoading = false;
    notifyListeners();
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