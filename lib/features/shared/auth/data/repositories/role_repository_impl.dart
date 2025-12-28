import 'package:dartz/dartz.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../domain/entities/user_role.dart';
import '../../domain/repositories/role_repository.dart';

class RoleRepositoryImpl implements RoleRepository {
  static const _key = 'user_role';

  @override
  Future<Either<String, UserRole>> setRole(UserRole role) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, role.name);
      return Right(role);
    } catch (_) {
      return const Left('failures.unexpected');
    }
  }

  @override
  Future<Either<String, UserRole>> getRole() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final value = prefs.getString(_key);
      if (value == null) return const Right(UserRole.client); // default
      return Right(UserRole.values.firstWhere((e) => e.name == value, orElse: () => UserRole.client));
    } catch (_) {
      return const Left('failures.unexpected');
    }
  }
}

