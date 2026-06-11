import '../../domain/entities/user.dart';

class RegisterResponseModel extends User {
  final String? token;

  const RegisterResponseModel({
    required super.id,
    required super.name,
    required super.email,
    required super.phone,
    super.countryCode,
    super.sex,
    super.materialStatus,
    super.otp,
    this.token,
  });

  factory RegisterResponseModel.fromJson(Map<String, dynamic> json) {
    return RegisterResponseModel(
      // Guard the non-nullable User fields against null/typed values. The
      // backend returns phone: null for accounts created without a phone
      // number (optional per App Store guideline 5.1.1); a raw cast would
      // throw and surface as "حدث خطأ غير متوقع".
      id: json['id'] is int
          ? json['id'] as int
          : int.tryParse('${json['id']}') ?? 0,
      name: json['name']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      countryCode: json['country_code']?.toString(),
      sex: json['sex']?.toString(),
      materialStatus: json['material_status']?.toString(),
      otp: json['otp']?.toString(),
      token: json['token']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'country_code': countryCode,
      'sex': sex,
      'material_status': materialStatus,
      'token': token,
    };
  }
}
