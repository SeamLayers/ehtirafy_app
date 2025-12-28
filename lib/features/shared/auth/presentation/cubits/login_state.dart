import 'package:equatable/equatable.dart';

import '../../domain/entities/login_result.dart';

abstract class LoginState extends Equatable {
  const LoginState();
  @override
  List<Object?> get props => [];
}

class LoginInitial extends LoginState {}
class LoginLoading extends LoginState {}
class LoginSuccess extends LoginState {
  final LoginResult result;
  const LoginSuccess(this.result);
  @override
  List<Object?> get props => [result];
}
class LoginError extends LoginState {
  final String failureKey; // use localization key from failures
  const LoginError(this.failureKey);
  @override
  List<Object?> get props => [failureKey];
}

