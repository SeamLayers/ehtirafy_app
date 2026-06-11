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
    final map = <String, dynamic>{
      'name': name,
      'email': email,
      'password': password,
      'password_confirmation': passwordConfirmation,
      'user_type': userType,
      'country_code': countryCode,
      'device_token': deviceToken,
    };
    // Phone is optional (App Store guideline 5.1.1). Only include it when the
    // user actually provided one. Sending an empty string makes Laravel's
    // ConvertEmptyStringsToNull middleware turn it into null, which then fails
    // the backend "The phone must be a string." validation. Omitting the key
    // entirely lets the backend skip phone validation.
    if (phone.trim().isNotEmpty) {
      map['phone'] = phone;
    }
    return map;
  }
}
