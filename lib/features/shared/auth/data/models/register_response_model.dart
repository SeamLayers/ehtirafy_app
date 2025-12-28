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
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      countryCode: json['country_code'],
      sex: json['sex'],
      materialStatus: json['material_status'],
      otp: json['otp']?.toString(),
      token: json['token'],
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
