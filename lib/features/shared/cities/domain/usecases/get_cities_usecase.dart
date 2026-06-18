import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import '../entities/city_entity.dart';
import '../repositories/cities_repository.dart';

class GetCitiesUseCase {
  final CitiesRepository repository;

  GetCitiesUseCase(this.repository);

  Future<Either<Failure, List<CityEntity>>> call() async {
    return await repository.getCities();
  }
}
