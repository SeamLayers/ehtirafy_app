import 'package:dartz/dartz.dart';
import '../entities/user_role.dart';
import '../repositories/user_role_repository.dart';
import '../../../../../core/errors/failures.dart';

/// Use case to switch user role
class SwitchUserRole {
  final UserRoleRepository repository;

  SwitchUserRole(this.repository);

  Future<Either<Failure, UserRoleEntity>> call(UserRole newRole) async {
    return await repository.switchRole(newRole);
  }
}

