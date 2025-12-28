import 'package:equatable/equatable.dart';

class FreelancerStatistics extends Equatable {
  final int completedOrders;
  final double averageRating;
  final double totalEarnings;
  final int activeGigs;

  const FreelancerStatistics({
    required this.completedOrders,
    required this.averageRating,
    required this.totalEarnings,
    required this.activeGigs,
  });

  @override
  List<Object?> get props => [
    completedOrders,
    averageRating,
    totalEarnings,
    activeGigs,
  ];
}
