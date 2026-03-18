import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import '../entities/request_entity.dart';
import '../repositories/requests_repository.dart';

class GetMyRequestsUseCase {
  final RequestsRepository repository;

  GetMyRequestsUseCase(this.repository);

  Future<Either<Failure, List<RequestEntity>>> call() async {
    return await repository.getMyRequests();
  }
}
