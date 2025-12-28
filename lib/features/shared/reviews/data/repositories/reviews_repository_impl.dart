import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/exceptions.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/features/shared/reviews/data/datasources/reviews_remote_data_source.dart';
import 'package:ehtirafy_app/features/shared/reviews/domain/entities/review_entity.dart';
import 'package:ehtirafy_app/features/shared/reviews/domain/repositories/reviews_repository.dart';

class ReviewsRepositoryImpl implements ReviewsRepository {
  final ReviewsRemoteDataSource remoteDataSource;

  ReviewsRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Either<Failure, void>> addRate({
    required String ratedUserId,
    required String advertisementId,
    required double rating,
    required String comment,
  }) async {
    try {
      await remoteDataSource.addRate(
        ratedUserId: ratedUserId,
        advertisementId: advertisementId,
        rating: rating,
        comment: comment,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ReviewEntity>>> getUserRates({
    required String userId,
  }) async {
    try {
      final reviews = await remoteDataSource.getUserRates(userId: userId);
      return Right(reviews);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
