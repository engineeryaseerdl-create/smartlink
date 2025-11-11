enum VehicleType { okada, car }

class RiderModel {
  final String id;
  final String name;
  final String phone;
  final String email;
  final VehicleType vehicleType;
  final String vehiclePlate;
  final String location;
  final String? profileImage;
  final double rating;
  final int totalDeliveries;
  final bool isAvailable;
  final bool isVerified;
  final double? currentLat;
  final double? currentLng;

  RiderModel({
    required this.id,
    required this.name,
    required this.phone,
    required this.email,
    required this.vehicleType,
    required this.vehiclePlate,
    required this.location,
    this.profileImage,
    this.rating = 5.0,
    this.totalDeliveries = 0,
    this.isAvailable = true,
    this.isVerified = false,
    this.currentLat,
    this.currentLng,
  });

  factory RiderModel.fromJson(Map<String, dynamic> json) {
    return RiderModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      vehicleType: VehicleType.values.firstWhere(
        (e) => e.toString() == 'VehicleType.${json['vehicleType']}',
        orElse: () => VehicleType.okada,
      ),
      vehiclePlate: json['vehiclePlate'] ?? '',
      location: json['location'] ?? '',
      profileImage: json['profileImage'],
      rating: (json['rating'] ?? 5.0).toDouble(),
      totalDeliveries: json['totalDeliveries'] ?? 0,
      isAvailable: json['isAvailable'] ?? true,
      isVerified: json['isVerified'] ?? false,
      currentLat: json['currentLat']?.toDouble(),
      currentLng: json['currentLng']?.toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'vehicleType': vehicleType.toString().split('.').last,
      'vehiclePlate': vehiclePlate,
      'location': location,
      'profileImage': profileImage,
      'rating': rating,
      'totalDeliveries': totalDeliveries,
      'isAvailable': isAvailable,
      'isVerified': isVerified,
      'currentLat': currentLat,
      'currentLng': currentLng,
    };
  }
}
