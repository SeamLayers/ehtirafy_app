import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/work_details_entity.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/repositories/freelancer_repository.dart';

class GetWorkDetailsUseCase {
  final FreelancerRepository repository;

  GetWorkDetailsUseCase(this.repository);

  Future<Either<Failure, WorkDetailsEntity>> call(String id) async {
    return await repository.getWorkDetails(id);
  }
}
