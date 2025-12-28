import 'package:dartz/dartz.dart';
import '../../../../../core/error/failures.dart';
import '../repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;

  ResetPasswordUseCase(this.repository);

  Future<Either<Failure, String>> call({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    return await repository.resetPassword(
      email: email,
      otp: otp,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );
  }
}
