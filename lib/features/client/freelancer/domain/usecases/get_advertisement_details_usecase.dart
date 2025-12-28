import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/advertisement_details_entity.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/repositories/freelancer_repository.dart';

class GetAdvertisementDetailsUseCase {
  final FreelancerRepository repository;

  GetAdvertisementDetailsUseCase(this.repository);

  Future<Either<Failure, AdvertisementDetailsEntity>> call(String id) async {
    return await repository.getAdvertisementDetails(id);
  }
}
