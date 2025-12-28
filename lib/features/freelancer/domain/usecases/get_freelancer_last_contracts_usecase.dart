import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/freelancer_last_contract.dart';
import '../repositories/freelancer_dashboard_repository.dart';

class GetFreelancerLastContractsUseCase {
  final FreelancerDashboardRepository repository;

  GetFreelancerLastContractsUseCase(this.repository);

  Future<Either<Failure, List<FreelancerLastContract>>> call(
    int freelancerId,
  ) async {
    return await repository.getLastContracts(freelancerId);
  }
}
