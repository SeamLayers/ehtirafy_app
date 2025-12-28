import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/features/shared/reviews/domain/entities/review_entity.dart';
import 'package:ehtirafy_app/features/shared/reviews/domain/repositories/reviews_repository.dart';

class GetUserRatesUseCase {
  final ReviewsRepository repository;

  GetUserRatesUseCase(this.repository);

  Future<Either<Failure, List<ReviewEntity>>> call({
    required String userId,
  }) async {
    return await repository.getUserRates(userId: userId);
  }
}
