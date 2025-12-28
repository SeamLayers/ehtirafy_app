import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/features/shared/reviews/domain/repositories/reviews_repository.dart';

class AddRateUseCase {
  final ReviewsRepository repository;

  AddRateUseCase(this.repository);

  Future<Either<Failure, void>> call({
    required String ratedUserId,
    required String advertisementId,
    required double rating,
    required String comment,
  }) async {
    return await repository.addRate(
      ratedUserId: ratedUserId,
      advertisementId: advertisementId,
      rating: rating,
      comment: comment,
    );
  }
}
