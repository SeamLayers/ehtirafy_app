import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ehtirafy_app/core/domain/usecase.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import '../repositories/auth_repository.dart';

class ForgotPasswordUseCase implements UseCase<String, ForgotPasswordParams> {
  final AuthRepository repo;
  ForgotPasswordUseCase(this.repo);

  @override
  Future<Either<Failure, String>> call(ForgotPasswordParams params) {
    return repo.forgotPassword(params.email);
  }
}

class ForgotPasswordParams extends Equatable {
  final String email;

  const ForgotPasswordParams({required this.email});

  @override
  List<Object> get props => [email];
}
