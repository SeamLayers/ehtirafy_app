import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/photographer_entity.dart';
import 'package:ehtirafy_app/features/client/home/domain/repositories/home_repository.dart';

/// Fetches all published advertisements for the home "All" tab feed
/// (GET /front/advertisements?user_type=customer). Each ad carries a city.
class GetAllAdvertisementsUseCase {
  final HomeRepository repository;

  GetAllAdvertisementsUseCase(this.repository);

  Future<Either<Failure, List<PhotographerEntity>>> call() async {
    return await repository.getAllAdvertisements();
  }
}
