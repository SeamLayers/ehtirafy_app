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
      id: _asInt(json['id']),
      clientName: json['client_name']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      date: json['date']?.toString() ?? '',
      amount: _asDouble(json['amount']),
      status: json['status']?.toString() ?? '',
      clientAvatar: json['client_avatar']?.toString(),
    );
  }
}

int _asInt(dynamic v) =>
    (v is num) ? v.toInt() : int.tryParse(v?.toString() ?? '') ?? 0;

double _asDouble(dynamic v) =>
    (v is num) ? v.toDouble() : double.tryParse(v?.toString() ?? '') ?? 0.0;
