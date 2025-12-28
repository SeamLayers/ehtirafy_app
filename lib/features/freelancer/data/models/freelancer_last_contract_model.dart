import '../../domain/entities/freelancer_last_contract.dart';

class FreelancerLastContractModel extends FreelancerLastContract {
  const FreelancerLastContractModel({
    required super.id,
    required super.clientName,
    required super.title,
    required super.date,
    required super.amount,
    required super.status,
    required super.clientAvatar,
  });

  factory FreelancerLastContractModel.fromJson(Map<String, dynamic> json) {
    return FreelancerLastContractModel(
      id: json['id'],
      clientName: json['client_name'] ?? '',
      title: json['title'] ?? '',
      date: json['date'] ?? '',
      amount: (json['amount'] ?? 0).toDouble(),
      status: json['status'] ?? '',
      clientAvatar: json['client_avatar'],
    );
  }
}
