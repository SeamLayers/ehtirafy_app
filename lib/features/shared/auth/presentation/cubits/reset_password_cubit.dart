import 'package:bloc/bloc.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import 'reset_password_state.dart';

class ResetPasswordCubit extends Cubit<ResetPasswordState> {
  final ResetPasswordUseCase _resetPasswordUseCase;

  ResetPasswordCubit(this._resetPasswordUseCase)
    : super(ResetPasswordInitial());

  Future<void> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    emit(ResetPasswordLoading());

    final result = await _resetPasswordUseCase(
      email: email,
      otp: otp,
      password: password,
      passwordConfirmation: passwordConfirmation,
    );

    result.fold(
      (failure) => emit(ResetPasswordError(failure.message)),
      (message) => emit(ResetPasswordSuccess(message)),
    );
  }
}
