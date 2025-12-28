import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user.dart';

abstract class UserLocalDataSource {
  Future<void> saveUser(User user);
  Future<User?> getUser();
  Future<void> saveToken(String token);
  Future<String?> getToken();
  Future<void> clearUserData();
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final SharedPreferences sharedPreferences;

  UserLocalDataSourceImpl({required this.sharedPreferences});

  static const String _userKey = 'cached_user';
  static const String _tokenKey = 'cached_token';

  @override
  Future<void> saveUser(User user) async {
    // Assuming User has a toJson method via UserModel or we convert it manually.
    // Ideally we should save UserModel.
    // If User is entity, we need to cast to UserModel or map it.
    // Let's assume we can convert it to map.
    // Since UserModel likely extends User, we might need to rely on UserModel here.
    // But interface uses User. We will check UserModel in next steps.
    // specific implementation depends on UserModel availability.

    // Quick fix: user UserModel.fromEntity(user) if exists or cast.
    // For now I will assume passed user is UserModel or I can create one.

    // We can rely on a utility or model. Since UserModel was not found, let's use a simple Map for now or define a local model if needed.
    // However, we need to be consistent.
    // If we look at LoginModel (which I will inspect right now), it might contain the User parsing logic.
    // For now, I'll store the basic fields available in User entity to avoid errors.

    final userData = {
      'id': user.id,
      'name': user.name,
      'email': user.email,
      'phone': user.phone,
      'country_code': user.countryCode,
      'sex': user.sex,
      'material_status': user.materialStatus,
      // 'user_type': user.userType, // Not in User entity apparently?
      // 'city_id': user.cityId,
      // 'city_name': user.cityName,
      // 'profile_image': user.profileImage,
    };

    await sharedPreferences.setString(_userKey, json.encode(userData));
  }

  @override
  Future<User?> getUser() async {
    final jsonString = sharedPreferences.getString(_userKey);
    if (jsonString != null) {
      try {
        final jsonMap = json.decode(jsonString);

        // Helper to safely get string value, handling potential Map types
        String? safeString(dynamic value) {
          if (value == null) return null;
          if (value is String) return value;
          if (value is Map) return null; // Skip if it's a Map (localized data)
          return value.toString();
        }

        // Helper to get int value
        int safeInt(dynamic value) {
          if (value == null) return 0;
          if (value is int) return value;
          if (value is String) return int.tryParse(value) ?? 0;
          return 0;
        }

        return User(
          id: safeInt(jsonMap['id']),
          name: safeString(jsonMap['name']) ?? '',
          email: safeString(jsonMap['email']) ?? '',
          phone: safeString(jsonMap['phone']) ?? '',
          countryCode: safeString(jsonMap['country_code']),
          sex: safeString(jsonMap['sex']),
          materialStatus: safeString(jsonMap['material_status']),
        );
      } catch (e) {
        // JSON parsing failed
        return null;
      }
    }
    return null;
  }

  @override
  Future<void> saveToken(String token) async {
    await sharedPreferences.setString(_tokenKey, token);
  }

  @override
  Future<String?> getToken() async {
    return sharedPreferences.getString(_tokenKey);
  }

  @override
  Future<void> clearUserData() async {
    await sharedPreferences.remove(_userKey);
    await sharedPreferences.remove(_tokenKey);
  }
}
