import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import '../entities/portfolio_item_entity.dart';

abstract class FreelancerPortfolioRepository {
  /// Get all portfolio items
  Future<Either<Failure, List<PortfolioItemEntity>>> getPortfolio();
  Future<Either<Failure, PortfolioItemEntity>> addPortfolioItem({
    required String title,
    required String description,
    String? imagePath,
  });
  Future<Either<Failure, PortfolioItemEntity>> updatePortfolioItem({
    required String id,
    required String title,
    required String description,
    String? imagePath,
  });
  Future<Either<Failure, void>> deletePortfolioItem(String id);
}
