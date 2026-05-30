import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import '../repositories/auth_repository.dart';
import 'package:ehtirafy_app/core/domain/usecase.dart';

class DeleteAccountUseCase implements UseCase<void, String> {
  final AuthRepository repo;

  DeleteAccountUseCase(this.repo);

  @override
  Future<Either<Failure, void>> call(String userId) {
    return repo.deleteAccount(userId);
  }
}
