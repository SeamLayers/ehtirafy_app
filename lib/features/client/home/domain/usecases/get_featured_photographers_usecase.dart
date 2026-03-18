import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/photographer_entity.dart';
import 'package:ehtirafy_app/features/client/home/domain/repositories/home_repository.dart';

class GetFeaturedPhotographersUseCase {
  final HomeRepository repository;

  GetFeaturedPhotographersUseCase(this.repository);

  Future<Either<Failure, List<PhotographerEntity>>> call() async {
    return await repository.getFeaturedPhotographers();
  }
}
