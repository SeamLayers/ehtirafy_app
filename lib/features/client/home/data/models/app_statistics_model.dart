import '../../domain/entities/app_statistics.dart';

class AppStatisticsModel extends AppStatistics {
  const AppStatisticsModel({
    required super.usersCount,
    required super.servicesCount,
    required super.contractsCount,
    required super.completedContracts,
    required super.totalEarnings,
    required super.worksCount,
    required super.ratingsCount,
    required super.ratingAvg,
  });

  factory AppStatisticsModel.fromJson(Map<String, dynamic> json) {
    // Helper to parse int from dynamic (can be int or String)
    int parseIntValue(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is String) return int.tryParse(value) ?? 0;
      return 0;
    }

    // Helper to parse num from dynamic (can be int, double, or String)
    num parseNumValue(dynamic value) {
      if (value == null) return 0;
      if (value is num) return value;
      if (value is String) return num.tryParse(value) ?? 0;
      return 0;
    }

    return AppStatisticsModel(
      usersCount: parseIntValue(json['users_count']),
      servicesCount: parseIntValue(json['services_count']),
      contractsCount: parseIntValue(json['contracts_count']),
      completedContracts: parseIntValue(json['completed_contracts']),
      totalEarnings: parseNumValue(json['total_earnings']),
      worksCount: parseIntValue(json['works_count']),
      ratingsCount: parseIntValue(json['ratings_count']),
      ratingAvg: parseNumValue(json['rating_avg']),
    );
  }
}
