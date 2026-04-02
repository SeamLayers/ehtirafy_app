// ignore_for_file: non_constant_identifier_names

class RegisterRequestParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String sex;
  final String materialStatus;
  final String phone;
  final String identity_number;
  final String userType;
  final String countryCode;
  final String deviceToken;

  RegisterRequestParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.sex,
    required this.materialStatus,
    required this.phone,
    required this.identity_number,
    required this.userType,
    required this.countryCode,
    required this.deviceToken,
  });

  Map<String, dynamic> toJson() {
    final int? identityNumberAsInt = int.tryParse(identity_number);
    final dynamic identityNumberValue = identityNumberAsInt ?? identity_number;

    return {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'sex': sex,
      'material_status': materialStatus,
      'phone': phone,
      'identity_number': identityNumberValue,
      'Identity_number': identityNumberValue,
      'user_type': userType,
      'country_code': countryCode,
      'device_token': deviceToken,
    };
  }
}
