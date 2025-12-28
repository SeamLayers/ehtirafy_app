import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/core/domain/usecase.dart';
import '../repositories/auth_repository.dart';

import 'send_otp_params.dart';

class SendOtpUseCase implements UseCase<String, SendOtpParams> {
  final AuthRepository repository;

  SendOtpUseCase(this.repository);

  @override
  Future<Either<Failure, String>> call(SendOtpParams params) async {
    return await repository.sendOtp(params.phone, params.countryCode);
  }
}
