import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/repositories/freelancer_repository.dart';

class GetFreelancerPhoneUseCase {
  final FreelancerRepository repository;

  GetFreelancerPhoneUseCase(this.repository);

  Future<Either<Failure, String>> call(String id) async {
    return await repository.getFreelancerPhone(id);
  }
}
