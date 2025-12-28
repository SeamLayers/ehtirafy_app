import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

import 'package:equatable/equatable.dart';
import 'package:ehtirafy_app/core/domain/usecase.dart';

class SignupUseCase implements UseCase<User, SignupParams> {
  final AuthRepository repo;
  SignupUseCase(this.repo);

  @override
  Future<Either<Failure, User>> call(SignupParams params) {
    return repo.signup(
      fullName: params.fullName,
      email: params.email,
      phone: params.phone,
      password: params.password,
      passwordConfirmation: params.passwordConfirmation,
      sex: params.sex,
      materialStatus: params.materialStatus,
      userType: params.userType,
      countryCode: params.countryCode,
      deviceToken: params.deviceToken,
    );
  }
}

class SignupParams extends Equatable {
  final String fullName;
  final String email;
  final String phone;
  final String password;
  final String passwordConfirmation;
  final String sex;
  final String materialStatus;
  final String userType;
  final String countryCode;
  final String deviceToken;

  const SignupParams({
    required this.fullName,
    required this.email,
    required this.phone,
    required this.password,
    required this.passwordConfirmation,
    required this.sex,
    required this.materialStatus,
    required this.userType,
    required this.countryCode,
    required this.deviceToken,
  });

  @override
  List<Object> get props => [
    fullName,
    email,
    phone,
    password,
    passwordConfirmation,
    sex,
    materialStatus,
    userType,
    countryCode,
    deviceToken,
  ];
}
