import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

class SwitchUserRoleUseCase {
  final ProfileRepository repository;

  SwitchUserRoleUseCase(this.repository);

  Future<Either<Failure, UserProfileEntity>> call(UserRole newRole) async {
    return await repository.switchUserRole(newRole);
  }
}
