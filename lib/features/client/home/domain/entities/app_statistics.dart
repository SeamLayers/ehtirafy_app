import 'package:equatable/equatable.dart';

class AppStatistics extends Equatable {
  final int usersCount;
  final int servicesCount;
  final int contractsCount;
  final int completedContracts;
  final num totalEarnings;
  final int worksCount;
  final int ratingsCount;
  final num ratingAvg;

  const AppStatistics({
    required this.usersCount,
    required this.servicesCount,
    required this.contractsCount,
    required this.completedContracts,
    required this.totalEarnings,
    required this.worksCount,
    required this.ratingsCount,
    required this.ratingAvg,
  });

  @override
  List<Object> get props => [
    usersCount,
    servicesCount,
    contractsCount,
    completedContracts,
    totalEarnings,
    worksCount,
    ratingsCount,
    ratingAvg,
  ];
}
