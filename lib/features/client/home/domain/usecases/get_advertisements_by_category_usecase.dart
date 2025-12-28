import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/photographer_entity.dart';
import 'package:ehtirafy_app/features/client/home/domain/repositories/home_repository.dart';

class GetAdvertisementsByCategoryUseCase {
  final HomeRepository repository;

  GetAdvertisementsByCategoryUseCase(this.repository);

  Future<Either<Failure, List<PhotographerEntity>>> call(String categoryId) {
    return repository.getAdvertisementsByCategory(categoryId);
  }
}
