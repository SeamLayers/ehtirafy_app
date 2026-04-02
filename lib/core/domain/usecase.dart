import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';

abstract class UseCase<ResultType, Params> {
  Future<Either<Failure, ResultType>> call(Params params);
}

class NoParams {
  const NoParams();
}
