import 'package:dartz/dartz.dart';
import '../entities/user_role.dart';
import '../../../../../core/errors/failures.dart';

/// Abstract repository for managing user role
abstract class UserRoleRepository {
  /// Get the current user role
  Future<Either<Failure, UserRoleEntity>> getCurrentRole();

  /// Switch to a different role
  Future<Either<Failure, UserRoleEntity>> switchRole(UserRole newRole);

  /// Save the user role
  Future<Either<Failure, Unit>> saveRole(UserRole role);

  /// Stream of role changes
  Stream<UserRoleEntity> watchRoleChanges();

  /// Clear saved role (logout)
  Future<Either<Failure, Unit>> clearRole();
}

