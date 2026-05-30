// ignore_for_file: non_constant_identifier_names

class RegisterRequestParams {
  final String name;
  final String email;
  final String password;
  final String passwordConfirmation;
  final String phone;
  final String userType;
  final String countryCode;
  final String deviceToken;

  RegisterRequestParams({
    required this.name,
    required this.email,
    required this.password,
    required this.passwordConfirmation,
    required this.phone,
    required this.userType,
    required this.countryCode,
    required this.deviceToken,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'phone': phone,
      'user_type': userType,
      'country_code': countryCode,
      'device_token': deviceToken,
    };
  }
}
