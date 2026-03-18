import 'package:bloc/bloc.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import '../../domain/usecases/signup_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/send_otp_params.dart';
import 'signup_state.dart';

class SignupCubit extends Cubit<SignupState> {
  final SignupUseCase signupUseCase;
  final SendOtpUseCase sendOtpUseCase;

  SignupCubit(this.signupUseCase, this.sendOtpUseCase) : super(SignupInitial());

  Future<void> signup({
    required String fullName,
    required String email,
    required String phone,
    required String password,
    required String passwordConfirmation,
    required String sex,
    required String materialStatus,
    required String userType,
    required String countryCode,
    required String deviceToken,
  }) async {
    emit(SignupLoading());
    final result = await signupUseCase(
      SignupParams(
        fullName: fullName,
        email: email,
        phone: phone,
        password: password,
        passwordConfirmation: passwordConfirmation,
        sex: sex,
        materialStatus: materialStatus,
        userType: userType,
        countryCode: countryCode,
        deviceToken: deviceToken,
      ),
    );
    result.fold(
      (failure) => emit(SignupError(_mapFailureToMessage(failure))),
      (user) => emit(SignupSuccess(user)),
    );
  }

  Future<void> sendOtp(String phone, String countryCode) async {
    emit(SignupLoading());
    final result = await sendOtpUseCase(
      SendOtpParams(phone: phone, countryCode: countryCode),
    );
    result.fold(
      (failure) => emit(SignupError(_mapFailureToMessage(failure))),
      (otp) => emit(SignupOtpSent(otp)),
    );
  }

  String _mapFailureToMessage(Failure failure) {
    if (failure is ServerFailure) return failure.message;
    if (failure is CacheFailure) return AppStrings.failureCache;
    if (failure is NetworkFailure) return AppStrings.failureNetwork;
    return AppStrings.failureUnexpected;
  }
}
