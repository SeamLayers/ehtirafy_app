enum UserRole { client, freelancer }

class UserProfileEntity {
  final String id;
  final String name;
  final String email;
  final String? avatarUrl;
  final String phone;
  final UserRole currentRole;

  // New API fields
  final String? sex;
  final String? materialStatus;
  final String? countryCode;
  final String? userType;
  final String? ipAddress;
  final String? createdAt;
  final String? updatedAt;

  // Freelancer specific fields
  final double? rating;
  final int? reviewCount;
  final String? bio;

  const UserProfileEntity({
    required this.id,
    required this.name,
    required this.email,
    this.avatarUrl,
    required this.phone,
    required this.currentRole,
    this.sex,
    this.materialStatus,
    this.countryCode,
    this.userType,
    this.ipAddress,
    this.createdAt,
    this.updatedAt,
    this.rating,
    this.reviewCount,
    this.bio,
  });

  UserProfileEntity copyWith({
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
    return UserProfileEntity(
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
}
