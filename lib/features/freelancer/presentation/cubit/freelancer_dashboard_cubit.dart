import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/freelancer_dashboard_repository.dart';
import '../../domain/entities/gig_entity.dart';
import '../../domain/entities/portfolio_item_entity.dart';
import '../../domain/entities/freelancer_statistics.dart';
import '../../domain/entities/freelancer_last_contract.dart';
import '../../domain/usecases/get_freelancer_statistics_usecase.dart';
import '../../domain/usecases/get_freelancer_last_contracts_usecase.dart';
import 'freelancer_dashboard_state.dart';

class FreelancerDashboardCubit extends Cubit<FreelancerDashboardState> {
  final FreelancerDashboardRepository repository;
  final GetFreelancerStatisticsUseCase _getFreelancerStatisticsUseCase;
  final GetFreelancerLastContractsUseCase _getFreelancerLastContractsUseCase;

  FreelancerDashboardCubit({
    required this.repository,
    required GetFreelancerStatisticsUseCase getFreelancerStatisticsUseCase,
    required GetFreelancerLastContractsUseCase
    getFreelancerLastContractsUseCase,
  }) : _getFreelancerStatisticsUseCase = getFreelancerStatisticsUseCase,
       _getFreelancerLastContractsUseCase = getFreelancerLastContractsUseCase,
       super(FreelancerDashboardInitial());

  Future<void> loadDashboard() async {
    emit(FreelancerDashboardLoading());

    // Get User ID from repository
    final userId = await repository.getUserId();
    if (userId == null) {
      emit(const FreelancerDashboardError('User not found'));
      return;
    }

    final userName = await repository.getUserName();

    // Fetch data via Future.wait for parallel execution
    // Map each future to handle errors individually
    final results = await Future.wait([
      // 0: Statistics
      _getFreelancerStatisticsUseCase(userId).then(
        (result) => result.fold(
          (l) => const FreelancerStatistics(
            completedOrders: 0,
            averageRating: 0.0,
            totalEarnings: 0.0,
            activeGigs: 0,
          ),
          (r) => r,
        ),
      ),
      // 1: Last Contracts
      _getFreelancerLastContractsUseCase(userId).then(
        (result) => result.fold((l) => <FreelancerLastContract>[], (r) => r),
      ),
      // 2: Portfolio
      repository.getPortfolioPreview().then(
        (result) => result.fold((l) => <PortfolioItemEntity>[], (r) => r),
      ),
      // 3: Gigs
      repository.getGigsPreview().then(
        (result) => result.fold((l) => <GigEntity>[], (r) => r),
      ),
    ]);

    final stats = results[0] as FreelancerStatistics;
    final lastContracts = results[1] as List<FreelancerLastContract>;
    final portfolioItems = results[2] as List<PortfolioItemEntity>;
    final gigs = results[3] as List<GigEntity>;

    // Always emit Loaded state, even if data is empty
    emit(
      FreelancerDashboardLoaded(
        stats: stats,
        portfolioItems: portfolioItems,
        gigs: gigs,
        lastContracts: lastContracts,
        userName: userName,
        isOnline: true, // Default to true
      ),
    );
  }

  Future<void> toggleOnlineStatus(bool isOnline) async {
    if (state is FreelancerDashboardLoaded) {
      final currentState = state as FreelancerDashboardLoaded;
      final result = await repository.toggleOnlineStatus(isOnline);

      result.fold((failure) {}, (newStatus) {
        emit(currentState.copyWith(isOnline: newStatus));
      });
    }
  }
}
