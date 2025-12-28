import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../entities/user_profile_entity.dart';
import '../repositories/profile_repository.dart';

class UpdateProfileUseCase {
  final ProfileRepository repository;

  UpdateProfileUseCase(this.repository);

  Future<Either<Failure, UserProfileEntity>> call(
    Map<String, dynamic> body,
  ) async {
    return await repository.updateProfile(body);
  }
}
