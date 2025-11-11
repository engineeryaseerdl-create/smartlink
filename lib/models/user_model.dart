enum UserRole { buyer, seller, rider }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final UserRole role;
  final String? location;
  final String? profileImage;
  final double? rating;
  final bool isVerified;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.location,
    this.profileImage,
    this.rating,
    this.isVerified = false,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'],
      role: UserRole.values.firstWhere(
        (e) => e.toString() == 'UserRole.${json['role']}',
        orElse: () => UserRole.buyer,
      ),
      location: json['location'],
      profileImage: json['profileImage'],
      rating: json['rating']?.toDouble(),
      isVerified: json['isVerified'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'role': role.toString().split('.').last,
      'location': location,
      'profileImage': profileImage,
      'rating': rating,
      'isVerified': isVerified,
    };
  }

  UserModel copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    UserRole? role,
    String? location,
    String? profileImage,
    double? rating,
    bool? isVerified,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      location: location ?? this.location,
      profileImage: profileImage ?? this.profileImage,
      rating: rating ?? this.rating,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
