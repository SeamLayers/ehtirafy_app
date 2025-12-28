import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/app_statistics.dart';
import 'package:ehtirafy_app/features/client/home/domain/repositories/home_repository.dart';

class GetAppStatisticsUseCase {
  final HomeRepository repository;

  GetAppStatisticsUseCase(this.repository);

  Future<Either<Failure, AppStatistics>> call() async {
    return await repository.getAppStatistics();
  }
}
