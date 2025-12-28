import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/photographer_entity.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/category_entity.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/app_statistics.dart';

abstract class HomeRepository {
  Future<Either<Failure, List<PhotographerEntity>>> getFeaturedPhotographers();
  Future<Either<Failure, List<PhotographerEntity>>> getAllFreelancers();
  Future<Either<Failure, List<CategoryEntity>>> getCategories();
  Future<Either<Failure, AppStatistics>> getAppStatistics();
  Future<Either<Failure, List<PhotographerEntity>>> getAdvertisementsByCategory(
    String categoryId,
  );
}
