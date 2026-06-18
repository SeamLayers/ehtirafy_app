import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import '../entities/city_entity.dart';

abstract class CitiesRepository {
  Future<Either<Failure, List<CityEntity>>> getCities();
}
