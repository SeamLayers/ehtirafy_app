import '../../domain/entities/freelancer_statistics.dart';

class FreelancerStatisticsModel extends FreelancerStatistics {
  const FreelancerStatisticsModel({
    required super.completedOrders,
    required super.averageRating,
    required super.totalEarnings,
    required super.activeGigs,
  });

  factory FreelancerStatisticsModel.fromJson(Map<String, dynamic> json) {
    return FreelancerStatisticsModel(
      completedOrders: json['completed_orders'] ?? 0,
      averageRating: (json['average_rating'] ?? 0).toDouble(),
      totalEarnings: (json['total_earnings'] ?? 0).toDouble(),
      activeGigs: json['active_gigs'] ?? 0,
    );
  }
}
