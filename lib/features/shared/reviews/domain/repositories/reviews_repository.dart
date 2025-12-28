import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/features/shared/reviews/domain/entities/review_entity.dart';

abstract class ReviewsRepository {
  Future<Either<Failure, void>> addRate({
    required String ratedUserId,
    required String advertisementId,
    required double rating,
    required String comment,
  });

  Future<Either<Failure, List<ReviewEntity>>> getUserRates({
    required String userId,
  });
}
