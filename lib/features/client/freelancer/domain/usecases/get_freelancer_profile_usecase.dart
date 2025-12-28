import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/freelancer_entity.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/repositories/freelancer_repository.dart';

class GetFreelancerProfileUseCase {
  final FreelancerRepository repository;

  GetFreelancerProfileUseCase(this.repository);

  Future<Either<Failure, FreelancerEntity>> call(String id) async {
    return await repository.getFreelancerProfile(id);
  }
}
