import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/freelancer_statistics.dart';
import '../repositories/freelancer_dashboard_repository.dart';

class GetFreelancerStatisticsUseCase {
  final FreelancerDashboardRepository repository;

  GetFreelancerStatisticsUseCase(this.repository);

  Future<Either<Failure, FreelancerStatistics>> call(int freelancerId) async {
    return await repository.getStatistics(freelancerId);
  }
}
