import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import 'package:ehtirafy_app/core/errors/exceptions.dart';
import 'package:ehtirafy_app/core/network/api_error_handler.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/user.dart';
import '../../domain/entities/login_result.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';
import '../datasources/user_local_data_source.dart';
import '../models/register_request_params.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final UserLocalDataSource localDataSource;

  AuthRepositoryImpl(this.remoteDataSource, this.localDataSource);

  @override
  Future<Either<Failure, LoginResult>> login({
    required String email,
    required String password,
    required String deviceToken,
  }) async {
    try {
      final result = await remoteDataSource.login(
        email: email,
        password: password,
        deviceToken: deviceToken,
      );

      // Persist user and token
      await localDataSource.saveUser(result.user);
      await localDataSource.saveToken(result.token);

      return Right(result);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, User>> signup({
    required String fullName,
    required String email,
    required String phone,
    required String identityNumber,
    required String password,
    required String passwordConfirmation,
    required String sex,
    required String materialStatus,
    required String userType,
    required String countryCode,
    required String deviceToken,
  }) async {
    try {
      final params = RegisterRequestParams(
        name: fullName,
        email: email,
        password: password,
        passwordConfirmation: passwordConfirmation,
        sex: sex,
        materialStatus: materialStatus,
        phone: phone,
        identity_number: identityNumber,
        userType: userType,
        countryCode: countryCode,
        deviceToken: deviceToken,
      );
      final result = await remoteDataSource.signup(params);
      await localDataSource.saveUser(result);

      // Save token if available (for auto-login)
      // Save token if available (for auto-login)
      if (result.token != null && result.token!.isNotEmpty) {
        debugPrint('Signup successful. Saving token: ${result.token}');
        await localDataSource.saveToken(result.token!);
      } else {
        debugPrint('Signup successful but NO TOKEN found in response.');
      }

      return Right(result);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, String>> forgotPassword(String email) async {
    try {
      final result = await remoteDataSource.forgotPassword(email);
      return Right(result);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, String>> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final result = await remoteDataSource.resetPassword(
        email: email,
        otp: otp,
        password: password,
        passwordConfirmation: passwordConfirmation,
      );
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> sendOtp(
    String phone,
    String countryCode,
  ) async {
    try {
      final response = await remoteDataSource.sendOtp(
        phone: phone,
        countryCode: countryCode,
      );
      return Right(response);
    } catch (e) {
      return Left(ApiErrorHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await remoteDataSource.logout();
      await localDataSource.clearUserData();
      return const Right(null);
    } catch (e) {
      return Left(CacheFailure(e.toString()));
    }
  }
}
