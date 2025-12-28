import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import '../entities/login_result.dart';
import '../entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, LoginResult>> login({
    required String email,
    required String password,
    required String deviceToken,
  });

  Future<Either<Failure, User>> signup({
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
  });

  Future<Either<Failure, String>> forgotPassword(String email);

  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  });

  Future<Either<Failure, String>> sendOtp(String phone, String countryCode);

  Future<Either<Failure, void>> logout();
}
