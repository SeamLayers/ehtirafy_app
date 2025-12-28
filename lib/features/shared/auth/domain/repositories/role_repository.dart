import 'package:dartz/dartz.dart';
import '../entities/user_role.dart';

abstract class RoleRepository {
  Future<Either<String, UserRole>> setRole(UserRole role);
  Future<Either<String, UserRole>> getRole();
}

