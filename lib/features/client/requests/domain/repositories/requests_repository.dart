import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import '../entities/request_entity.dart';

abstract class RequestsRepository {
  Future<Either<Failure, List<RequestEntity>>> getMyRequests();
}
