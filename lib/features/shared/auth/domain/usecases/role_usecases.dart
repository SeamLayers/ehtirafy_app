import 'package:dartz/dartz.dart';
import '../entities/user_role.dart';
import '../repositories/role_repository.dart';

class SetRoleUseCase {
  final RoleRepository repo;
  SetRoleUseCase(this.repo);
  Future<Either<String, UserRole>> call(UserRole role) => repo.setRole(role);
}

class GetRoleUseCase {
  final RoleRepository repo;
  GetRoleUseCase(this.repo);
  Future<Either<String, UserRole>> call() => repo.getRole();
}

