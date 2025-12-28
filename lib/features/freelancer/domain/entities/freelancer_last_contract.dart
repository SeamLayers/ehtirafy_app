import 'package:equatable/equatable.dart';

class FreelancerLastContract extends Equatable {
  final int id;
  final String clientName;
  final String title;
  final String date;
  final double amount;
  final String status;
  final String? clientAvatar;

  const FreelancerLastContract({
    required this.id,
    required this.clientName,
    required this.title,
    required this.date,
    required this.amount,
    required this.status,
    this.clientAvatar,
  });

  @override
  List<Object?> get props => [
    id,
    clientName,
    title,
    date,
    amount,
    status,
    clientAvatar,
  ];
}
