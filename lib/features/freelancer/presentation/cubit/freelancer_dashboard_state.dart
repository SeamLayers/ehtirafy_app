import 'package:equatable/equatable.dart';
import '../../domain/entities/gig_entity.dart';
import '../../domain/entities/portfolio_item_entity.dart';
import '../../domain/entities/freelancer_statistics.dart';
import '../../domain/entities/freelancer_last_contract.dart';

abstract class FreelancerDashboardState extends Equatable {
  const FreelancerDashboardState();

  @override
  List<Object?> get props => [];
}

class FreelancerDashboardInitial extends FreelancerDashboardState {}

class FreelancerDashboardLoading extends FreelancerDashboardState {}

class FreelancerDashboardLoaded extends FreelancerDashboardState {
  final FreelancerStatistics stats;
  final List<PortfolioItemEntity> portfolioItems;
  final List<GigEntity> gigs;
  final List<FreelancerLastContract> lastContracts;
  final String userName;
  final bool isOnline;

  const FreelancerDashboardLoaded({
    required this.stats,
    required this.portfolioItems,
    required this.gigs,
    required this.lastContracts,
    this.userName = 'أحمد المصور',
    this.isOnline = true,
  });

  @override
  List<Object?> get props => [
    stats,
    portfolioItems,
    gigs,
    lastContracts,
    userName,
    isOnline,
  ];

  FreelancerDashboardLoaded copyWith({
    FreelancerStatistics? stats,
    List<PortfolioItemEntity>? portfolioItems,
    List<GigEntity>? gigs,
    List<FreelancerLastContract>? lastContracts,
    String? userName,
    bool? isOnline,
  }) {
    return FreelancerDashboardLoaded(
      stats: stats ?? this.stats,
      portfolioItems: portfolioItems ?? this.portfolioItems,
      gigs: gigs ?? this.gigs,
      lastContracts: lastContracts ?? this.lastContracts,
      userName: userName ?? this.userName,
      isOnline: isOnline ?? this.isOnline,
    );
  }
}

class FreelancerDashboardError extends FreelancerDashboardState {
  final String message;

  const FreelancerDashboardError(this.message);

  @override
  List<Object?> get props => [message];
}
