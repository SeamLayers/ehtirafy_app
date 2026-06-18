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

  /// Whether the user has provided a phone number. A null phone is mapped to
  /// an empty string by [UserProfileModel.fromJson], so we detect "no phone"
  /// via an empty/whitespace check rather than a null check.
  bool get hasPhone => phone.trim().isNotEmpty;

  /// Profile completion as a percentage, driven by a simple 2-field model:
  /// the account base (name + email, always present after signup) covers 50%,
  /// and a present phone number adds the remaining 50%.
  int get completionPercent => hasPhone ? 100 : 50;

  /// Whether every tracked profile field is filled in.
  bool get isProfileComplete => completionPercent >= 100;

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
