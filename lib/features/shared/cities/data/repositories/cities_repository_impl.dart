import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import '../../domain/entities/city_entity.dart';
import '../../domain/repositories/cities_repository.dart';
import '../datasources/cities_remote_data_source.dart';

class CitiesRepositoryImpl implements CitiesRepository {
  final CitiesRemoteDataSource remoteDataSource;

  CitiesRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, List<CityEntity>>> getCities() async {
    try {
      final result = await remoteDataSource.getCities();
      return Right(result);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
