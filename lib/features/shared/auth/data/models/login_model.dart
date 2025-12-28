import '../../domain/entities/login_result.dart';
import '../models/register_response_model.dart';

class LoginModel extends LoginResult {
  const LoginModel({required super.user, required super.token});

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      user: RegisterResponseModel.fromJson(json['user']),
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    // We can't fully revert to original JSON structure without the User.toJson method
    // But typically models are for reading from API.
    return {
      'token': token,
      // 'user': user.toJson(), // Assuming user has toJson or we cast to model
    };
  }
}
