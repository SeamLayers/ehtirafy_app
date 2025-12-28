import 'package:equatable/equatable.dart';

abstract class SignupState extends Equatable {
  const SignupState();

  @override
  List<Object> get props => [];
}

class SignupInitial extends SignupState {}

class SignupLoading extends SignupState {}

class SignupSuccess extends SignupState {
  final dynamic user; // Using dynamic or User entity
  const SignupSuccess(this.user);
  @override
  List<Object> get props => [user];
}

class SignupOtpSent extends SignupState {
  final String otp;
  const SignupOtpSent(this.otp);
  @override
  List<Object> get props => [otp];
}

class SignupError extends SignupState {
  final String failureKey;

  const SignupError(this.failureKey);

  @override
  List<Object> get props => [failureKey];
}
