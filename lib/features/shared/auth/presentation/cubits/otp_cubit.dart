import 'dart:async';
import 'package:bloc/bloc.dart';

abstract class OtpState {
  const OtpState();
}

class OtpInitial extends OtpState {}

class OtpTick extends OtpState {
  final int remaining;
  const OtpTick(this.remaining);
}

class OtpVerifying extends OtpState {}

class OtpVerified extends OtpState {}

class OtpError extends OtpState {
  final String failureKey;
  const OtpError(this.failureKey);
}

class OtpResent extends OtpState {}

class OtpCubit extends Cubit<OtpState> {
  static const int initialSeconds = 60;
  int _remaining = initialSeconds;
  Timer? _timer;
  final List<String> _digits = ['', '', '', ''];

  OtpCubit() : super(OtpInitial()) {
    startTimer();
  }

  void startTimer() {
    _remaining = initialSeconds;
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      _remaining--;
      if (_remaining <= 0) {
        t.cancel();
        emit(const OtpTick(0));
      } else {
        emit(OtpTick(_remaining));
      }
    });
  }

  void updateDigit(int index, String value) {
    if (index < 0 || index > 3) return;
    _digits[index] = value.isEmpty ? '' : value[0];
  }

  bool get canVerify => _digits.every((d) => d.isNotEmpty);
  String get code => _digits.join();

  Future<void> verify({String? expectedOtp}) async {
    if (!canVerify) return;
    emit(OtpVerifying());
    await Future.delayed(const Duration(milliseconds: 300));

    print('Verifying OTP. Entered: $code, Expected: $expectedOtp');

    // Check against expected OTP if provided, otherwise default (or API in future)
    if (expectedOtp != null) {
      if (code == expectedOtp) {
        emit(OtpVerified());
      } else {
        emit(const OtpError('failures.validation'));
      }

      // User deleted the fallback block, preserving that structure.
      // However, if expectedOtp is null, we stay stuck in verifying or need to emit error?
      // Added fallback error just in case expectedOtp is missing to avoid stuck state.
    } else {
      print('Error: verify called but expectedOtp is null');
      emit(const OtpError('failures.validation'));
    }
  }

  Future<void> resend() async {
    if (_remaining > 0) return; // only allow when timer finished
    emit(OtpResent());
    await Future.delayed(const Duration(milliseconds: 300));
    startTimer();
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
