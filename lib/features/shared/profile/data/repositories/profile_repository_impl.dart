import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../../core/errors/failures.dart';
import '../../domain/entities/user_profile_entity.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_datasource.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, UserProfileEntity>> getUserProfile() async {
    try {
      final userModel = await remoteDataSource.getUserProfile();
      return Right(userModel);
    } catch (e) {
      if (e is DioException) {
        final message =
            e.response?.data['message'] ?? e.message ?? e.toString();
        return Left(ServerFailure(message));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> switchUserRole(
    UserRole newRole,
  ) async {
    try {
      final userModel = await remoteDataSource.switchUserRole(newRole);
      return Right(userModel);
    } catch (e) {
      if (e is DioException) {
        final message =
            e.response?.data['message'] ?? e.message ?? e.toString();
        return Left(ServerFailure(message));
      }
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserProfileEntity>> updateProfile(
    Map<String, dynamic> body,
  ) async {
    try {
      final userModel = await remoteDataSource.updateProfile(body);
      return Right(userModel);
    } catch (e) {
      if (e is DioException) {
        final message =
            e.response?.data['message'] ?? e.message ?? e.toString();
        return Left(ServerFailure(message));
      }
      return Left(ServerFailure(e.toString()));
    }
  }
}
