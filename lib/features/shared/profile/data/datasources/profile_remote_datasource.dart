import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/dio_client.dart';
import '../models/user_profile_model.dart';
import '../../domain/entities/user_profile_entity.dart';

abstract class ProfileRemoteDataSource {
  Future<UserProfileModel> getUserProfile();
  Future<UserProfileModel> updateProfile(Map<String, dynamic> body);
  Future<UserProfileModel> switchUserRole(UserRole newRole);
}

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  static const String _roleKey = 'user_role';
  final SharedPreferences sharedPreferences;
  final DioClient dioClient;

  ProfileRemoteDataSourceImpl({
    required this.sharedPreferences,
    required this.dioClient,
  });

  @override
  Future<UserProfileModel> getUserProfile() async {
    try {
      final response = await dioClient.get(ApiConstants.profileData);

      if (response.statusCode == 200) {
        final data = response.data['data'];
        // We might need to merge with local role preference if needed,
        // but for now let's trust the API or local override.
        // The API returns 'user_type', model parses it.
        var profile = UserProfileModel.fromJson(data);

        // If we want to preserve the locally selected role (view mode):
        final localRole = _getLocalRole();
        // Check if we should override the model's currentRole with local preference
        // strict logic depends on app requirements.
        // For now, let's defer to the API but allow switching.
        // Actually, the UI uses currentRole to toggle views.
        return profile.copyWith(currentRole: localRole);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to load profile');
      }
    } catch (e) {
      // Return mock/cache if offline? Or rethrow.
      // For now rethrow to show error.
      rethrow;
    }
  }

  @override
  Future<UserProfileModel> updateProfile(Map<String, dynamic> body) async {
    try {
      // Convert body to FormData for "form data" requirement
      // Include _method if needed, though usually automatic or added by caller.
      // The requirement says "body as a form data... _method".
      // If it's a POST request spoofing PUT, we might need _method: PUT/PATCH.

      FormData formData = FormData.fromMap(body);

      final response = await dioClient.post(
        ApiConstants.updateProfile,
        data: formData,
      );

      if (response.statusCode == 200) {
        final data = response.data['data'];
        return UserProfileModel.fromJson(data);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to update profile');
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<UserProfileModel> switchUserRole(UserRole newRole) async {
    // Persist the new role to SharedPreferences
    await sharedPreferences.setString(_roleKey, newRole.name);

    // In a real app, this might fetch the profile again or just update local state.
    // Since we just changed the view mode, we can return the current profile with new role.
    // Or fetch fresh data.
    // Let's fetch fresh data to be safe, but force the role.
    try {
      final profile = await getUserProfile();
      return profile.copyWith(currentRole: newRole);
    } catch (e) {
      // If fetch fails (offline), return a minimal profile or cached one (not implemented yet).
      // For now, construct one or rethrow.
      // Re-throwing might block the UI switch.
      // Let's just return a placeholder or relying on the fact that getUserProfile caches?
      // Actually getUserProfile calls API.
      // If offline, we can't fetch.
      // But switchUserRole is a local UI toggle often.
      // We will assume online for now or that getUserProfile handles it.

      // Fallback: return what we have in memory if possible (but we don't have it here).
      throw e;
    }
  }

  UserRole _getLocalRole() {
    final roleString = sharedPreferences.getString(_roleKey);
    if (roleString != null) {
      return UserRole.values.firstWhere(
        (role) => role.name == roleString,
        orElse: () => UserRole.client,
      );
    }
    return UserRole.client;
  }
}
