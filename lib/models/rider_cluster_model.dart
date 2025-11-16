import '../models/rider_model.dart';

class RiderCluster {
  final String id;
  final String name;
  final String location;
  final String leaderName;
  final String leaderPhone;
  final String? backupPhone;
  final List<ClusterMember> members;
  final bool isOnline;
  final double rating;
  final int totalDeliveries;
  final String operatingHours;
  final List<String> serviceAreas;
  final List<VehicleType> vehicleTypes;
  final DateTime createdAt;

  RiderCluster({
    required this.id,
    required this.name,
    required this.location,
    required this.leaderName,
    required this.leaderPhone,
    this.backupPhone,
    required this.members,
    this.isOnline = true,
    this.rating = 5.0,
    this.totalDeliveries = 0,
    this.operatingHours = '6AM - 10PM',
    this.serviceAreas = const [],
    this.vehicleTypes = const [VehicleType.okada],
    required this.createdAt,
  });

  factory RiderCluster.fromJson(Map<String, dynamic> json) {
    final leader = json['leader'] is Map ? json['leader'] : null;
    final backup = json['backupContact'] is Map ? json['backupContact'] : null;
    final location = json['location'] is Map ? json['location'] : null;
    final rating = json['rating'] is Map ? json['rating'] : null;
    
    return RiderCluster(
      id: json['_id'] ?? json['id'] ?? '',
      name: json['name'] ?? '',
      location: location?['address'] ?? json['location'] ?? '',
      leaderName: leader?['name'] ?? json['leaderName'] ?? '',
      leaderPhone: leader?['phone'] ?? json['leaderPhone'] ?? '',
      backupPhone: backup?['phone'] ?? json['backupPhone'],
      members: (json['members'] as List?)
          ?.map((m) => ClusterMember.fromJson(m))
          .toList() ?? [],
      isOnline: json['isOnline'] ?? true,
      rating: rating != null ? (rating['average'] ?? 5.0).toDouble() : (json['rating'] ?? 5.0).toDouble(),
      totalDeliveries: json['totalDeliveries'] ?? 0,
      operatingHours: json['operatingHours'] ?? '6AM - 10PM',
      serviceAreas: List<String>.from(json['serviceAreas'] ?? []),
      vehicleTypes: (json['vehicleTypes'] as List?)
          ?.map((v) => VehicleType.values.firstWhere(
              (e) => e.toString() == 'VehicleType.$v',
              orElse: () => VehicleType.okada))
          .toList() ?? [VehicleType.okada],
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'leaderName': leaderName,
      'leaderPhone': leaderPhone,
      'backupPhone': backupPhone,
      'members': members.map((m) => m.toJson()).toList(),
      'isOnline': isOnline,
      'rating': rating,
      'totalDeliveries': totalDeliveries,
      'operatingHours': operatingHours,
      'serviceAreas': serviceAreas,
      'vehicleTypes': vehicleTypes.map((v) => v.toString().split('.').last).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class ClusterMember {
  final String id;
  final String name;
  final String phone;
  final VehicleType vehicleType;
  final String vehiclePlate;
  final bool isLeader;
  final bool isActive;
  final double rating;
  final int deliveries;
  final DateTime joinedAt;

  ClusterMember({
    required this.id,
    required this.name,
    required this.phone,
    required this.vehicleType,
    required this.vehiclePlate,
    this.isLeader = false,
    this.isActive = true,
    this.rating = 5.0,
    this.deliveries = 0,
    required this.joinedAt,
  });

  factory ClusterMember.fromJson(Map<String, dynamic> json) {
    final rider = json['rider'] is Map ? json['rider'] : null;
    
    return ClusterMember(
      id: json['_id'] ?? json['id'] ?? '',
      name: rider?['name'] ?? json['name'] ?? '',
      phone: rider?['phone'] ?? json['phone'] ?? '',
      vehicleType: VehicleType.values.firstWhere(
        (e) => e.toString() == 'VehicleType.${rider?['vehicleType'] ?? json['vehicleType']}',
        orElse: () => VehicleType.okada,
      ),
      vehiclePlate: json['vehiclePlate'] ?? '',
      isLeader: json['isLeader'] ?? false,
      isActive: json['isActive'] ?? true,
      rating: (json['rating'] ?? 5.0).toDouble(),
      deliveries: json['deliveries'] ?? 0,
      joinedAt: DateTime.parse(json['joinedAt'] ?? DateTime.now().toIso8601String()),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'vehicleType': vehicleType.toString().split('.').last,
      'vehiclePlate': vehiclePlate,
      'isLeader': isLeader,
      'isActive': isActive,
      'rating': rating,
      'deliveries': deliveries,
      'joinedAt': joinedAt.toIso8601String(),
    };
  }
}