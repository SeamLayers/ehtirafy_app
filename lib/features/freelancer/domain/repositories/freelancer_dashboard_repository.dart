import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import '../entities/gig_entity.dart';
import '../entities/portfolio_item_entity.dart';
import '../entities/freelancer_statistics.dart';
import '../entities/freelancer_last_contract.dart';

abstract class FreelancerDashboardRepository {
  /// Get freelancer dashboard statistics
  /// Get freelancer dashboard statistics from API
  Future<Either<Failure, FreelancerStatistics>> getStatistics(int freelancerId);

  /// Get freelancer last contracts from API
  Future<Either<Failure, List<FreelancerLastContract>>> getLastContracts(
    int freelancerId,
  );

  /// Get portfolio items for dashboard preview
  Future<Either<Failure, List<PortfolioItemEntity>>> getPortfolioPreview();

  /// Get gigs for dashboard preview
  Future<Either<Failure, List<GigEntity>>> getGigsPreview();

  /// Toggle online/offline status
  Future<Either<Failure, bool>> toggleOnlineStatus(bool isOnline);
  Future<String> getUserName();
  Future<int?> getUserId();
}
