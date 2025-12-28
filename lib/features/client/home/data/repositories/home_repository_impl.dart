import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/features/client/home/data/datasources/home_remote_data_source.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/photographer_entity.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/category_entity.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/app_statistics.dart';
import 'package:ehtirafy_app/features/client/home/domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<PhotographerEntity>>>
  getFeaturedPhotographers() async {
    try {
      final result = await remoteDataSource.getFeaturedPhotographers();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PhotographerEntity>>> getAllFreelancers() async {
    try {
      final result = await remoteDataSource.getAllFreelancers();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<CategoryEntity>>> getCategories() async {
    try {
      final result = await remoteDataSource.getCategories();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AppStatistics>> getAppStatistics() async {
    try {
      final result = await remoteDataSource.getAppStatistics();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PhotographerEntity>>> getAdvertisementsByCategory(
    String categoryId,
  ) async {
    try {
      final result = await remoteDataSource.getAdvertisementsByCategory(
        categoryId,
      );
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
