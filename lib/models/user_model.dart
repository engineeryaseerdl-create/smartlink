enum UserRole { buyer, seller, rider }

class UserModel {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final UserRole role;
  final String? location;
  final String? profileImage;
  final String? profileImageUrl;
  final String? bio;
  final double? rating;
  final bool isVerified;
  final DateTime createdAt;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    required this.role,
    this.location,
    this.profileImage,
    this.profileImageUrl,
    this.bio,
    this.rating,
    this.isVerified = false,
    required this.createdAt,
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
      profileImageUrl: json['profileImageUrl'],
      bio: json['bio'],
      rating: json['rating']?.toDouble(),
      isVerified: json['isVerified'] ?? false,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
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
      'profileImageUrl': profileImageUrl,
      'bio': bio,
      'rating': rating,
      'isVerified': isVerified,
      'createdAt': createdAt.toIso8601String(),
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
    String? profileImageUrl,
    String? bio,
    double? rating,
    bool? isVerified,
    DateTime? createdAt,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      location: location ?? this.location,
      profileImage: profileImage ?? this.profileImage,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      bio: bio ?? this.bio,
      rating: rating ?? this.rating,
      isVerified: isVerified ?? this.isVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
