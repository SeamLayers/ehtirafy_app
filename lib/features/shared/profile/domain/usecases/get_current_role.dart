import 'package:dartz/dartz.dart';
import '../entities/user_role.dart';
import '../repositories/user_role_repository.dart';
import '../../../../../core/errors/failures.dart';

/// Use case to get the current user role
class GetCurrentRole {
  final UserRoleRepository repository;

  GetCurrentRole(this.repository);

  Future<Either<Failure, UserRoleEntity>> call() async {
    return await repository.getCurrentRole();
  }
}

