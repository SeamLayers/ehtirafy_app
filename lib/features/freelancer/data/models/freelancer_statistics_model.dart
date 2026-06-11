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
      completedOrders: _asInt(json['completed_orders']),
      averageRating: _asDouble(json['average_rating']),
      totalEarnings: _asDouble(json['total_earnings']),
      activeGigs: _asInt(json['active_gigs']),
    );
  }
}

int _asInt(dynamic v) =>
    (v is num) ? v.toInt() : int.tryParse(v?.toString() ?? '') ?? 0;

double _asDouble(dynamic v) =>
    (v is num) ? v.toDouble() : double.tryParse(v?.toString() ?? '') ?? 0.0;
