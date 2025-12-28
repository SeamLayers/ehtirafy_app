import '../../domain/entities/user_profile_entity.dart';

class UserProfileModel extends UserProfileEntity {
  const UserProfileModel({
    required super.id,
    required super.name,
    required super.email,
    super.avatarUrl,
    required super.phone,
    required super.currentRole,
    super.sex,
    super.materialStatus,
    super.countryCode,
    super.userType,
    super.ipAddress,
    super.createdAt,
    super.updatedAt,
    super.rating,
    super.reviewCount,
    super.bio,
  });

  factory UserProfileModel.fromJson(Map<String, dynamic> json) {
    return UserProfileModel(
      id: json['id'].toString(), // Convert int to String
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      avatarUrl: json['avatar_url'], // Assuming key, or null
      phone: json['phone'] ?? '',
      // Map user_type to UserRole or use default
      currentRole: _mapUserTypeToRole(json['user_type']),
      sex: json['sex'],
      materialStatus: json['material_status'],
      countryCode: json['country_code'],
      userType: json['user_type'],
      ipAddress: json['ip_address'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      // Keep existing logic for these if they exist
      rating: (json['rating'] as num?)?.toDouble(),
      reviewCount: json['reviewCount'],
      bio: json['bio'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'avatar_url': avatarUrl,
      'phone': phone,
      'user_type': userType,
      // 'currentRole': currentRole.toString().split('.').last, // Keep if needed for local storage
      'sex': sex,
      'material_status': materialStatus,
      'country_code': countryCode,
      'ip_address': ipAddress,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'rating': rating,
      'reviewCount': reviewCount,
      'bio': bio,
    };
  }

  @override
  UserProfileModel copyWith({
    String? id,
    String? name,
    String? email,
    String? avatarUrl,
    String? phone,
    UserRole? currentRole,
    String? sex,
    String? materialStatus,
    String? countryCode,
    String? userType,
    String? ipAddress,
    String? createdAt,
    String? updatedAt,
    double? rating,
    int? reviewCount,
    String? bio,
  }) {
    return UserProfileModel(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      phone: phone ?? this.phone,
      currentRole: currentRole ?? this.currentRole,
      sex: sex ?? this.sex,
      materialStatus: materialStatus ?? this.materialStatus,
      countryCode: countryCode ?? this.countryCode,
      userType: userType ?? this.userType,
      ipAddress: ipAddress ?? this.ipAddress,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      bio: bio ?? this.bio,
    );
  }

  static UserRole _mapUserTypeToRole(String? userType) {
    if (userType == 'freelancer') {
      return UserRole.freelancer;
    }
    return UserRole.client; // Default to client if 'user' or null
  }
}
