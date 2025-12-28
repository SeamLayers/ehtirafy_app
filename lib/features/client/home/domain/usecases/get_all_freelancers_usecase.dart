import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/photographer_entity.dart';
import 'package:ehtirafy_app/features/client/home/domain/repositories/home_repository.dart';

class GetAllFreelancersUseCase {
  final HomeRepository repository;

  GetAllFreelancersUseCase(this.repository);

  Future<Either<Failure, List<PhotographerEntity>>> call() async {
    return await repository.getAllFreelancers();
  }
}
