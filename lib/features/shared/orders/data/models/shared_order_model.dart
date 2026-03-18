import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_entity.dart';
import 'package:ehtirafy_app/features/shared/orders/domain/entities/shared_order_entity.dart';

class SharedOrderModel {
  final int id;
  final String title;
  final String? details;
  final double price;
  final ContractStatus status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String customerName;
  final String customerImage;
  final int customerId;
  final String freelancerName;
  final String freelancerImage;
  final int freelancerId;
  final int advertisementId;
  final bool isPaymentRequired;
  final DateTime? approvedDate;

  const SharedOrderModel({
    required this.id,
    required this.title,
    this.details,
    required this.price,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.customerName,
    required this.customerImage,
    required this.customerId,
    required this.freelancerName,
    required this.freelancerImage,
    required this.freelancerId,
    required this.advertisementId,
    required this.isPaymentRequired,
    this.approvedDate,
  });

  factory SharedOrderModel.fromJson(Map<String, dynamic> json) {
    final customer = json['customer'] as Map<String, dynamic>? ??
        json['user'] as Map<String, dynamic>? ??
        <String, dynamic>{};
    final freelancer = json['freelancer'] as Map<String, dynamic>? ??
        json['provider'] as Map<String, dynamic>? ??
        <String, dynamic>{};

    return SharedOrderModel(
      id: _toInt(json['id']),
      title: (json['title'] ?? json['service_title'] ?? '').toString(),
      details: json['details']?.toString(),
      price: _toDouble(json['price']),
        status: ContractStatusMapper.fromString(json['status']?.toString()),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? '') ??
          DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at']?.toString() ?? '') ??
          DateTime.now(),
      customerName: (customer['name'] ?? customer['username'] ?? '').toString(),
      customerImage: (customer['profile_image'] ?? customer['image'] ?? '').toString(),
      customerId: _toInt(customer['id']),
      freelancerName:
          (freelancer['name'] ?? freelancer['username'] ?? '').toString(),
      freelancerImage:
          (freelancer['profile_image'] ?? freelancer['image'] ?? '').toString(),
      freelancerId: _toInt(freelancer['id']),
      advertisementId: _toInt(json['advertisement_id']),
      isPaymentRequired: _toBool(json['is_payment_required']),
      approvedDate: DateTime.tryParse(json['approved_date']?.toString() ?? ''),
    );
  }

  factory SharedOrderModel.fromContract(ContractEntity contract) {
    return SharedOrderModel(
      id: contract.id,
      title: contract.serviceTitle ?? '',
      details: null,
      price: double.tryParse(contract.requestedAmount) ?? 0,
      status: contract.displayStatus,
      createdAt: contract.createdAt,
      updatedAt: contract.updatedAt,
      customerName: contract.clientName ?? '',
      customerImage: contract.clientImage ?? '',
      customerId: _toInt(contract.clientId),
      freelancerName: contract.photographerName ?? '',
      freelancerImage: contract.photographerImage ?? '',
      freelancerId: _toInt(contract.photographerId),
      advertisementId: _toInt(contract.advertisementId),
      isPaymentRequired: contract.displayStatus == ContractStatus.pendingPayment,
      approvedDate: contract.displayStatus == ContractStatus.inProgress
          ? contract.updatedAt
          : null,
    );
  }

  SharedOrderEntity toEntityForClient() {
    return SharedOrderEntity(
      id: id.toString(),
      serviceTitle: title,
      counterpartyName: freelancerName,
      counterpartyImage: freelancerImage,
      counterpartyId: freelancerId.toString(),
      advertisementId: advertisementId.toString(),
      status: SharedOrderEntity.fromContractStatus(status),
      price: price,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isPaymentRequired: isPaymentRequired,
      approvedDate: approvedDate,
    );
  }

  SharedOrderEntity toEntityForFreelancer() {
    return SharedOrderEntity(
      id: id.toString(),
      serviceTitle: title,
      counterpartyName: customerName,
      counterpartyImage: customerImage,
      counterpartyId: customerId.toString(),
      advertisementId: advertisementId.toString(),
      status: SharedOrderEntity.fromContractStatus(status),
      price: price,
      createdAt: createdAt,
      updatedAt: updatedAt,
      isPaymentRequired: isPaymentRequired,
      approvedDate: approvedDate,
    );
  }

  static int _toInt(dynamic value) {
    if (value is int) return value;
    if (value is String) return int.tryParse(value) ?? 0;
    return 0;
  }

  static double _toDouble(dynamic value) {
    if (value is double) return value;
    if (value is int) return value.toDouble();
    if (value is String) return double.tryParse(value) ?? 0;
    return 0;
  }

  static bool _toBool(dynamic value) {
    if (value is bool) return value;
    if (value is num) return value == 1;
    if (value is String) {
      final lower = value.toLowerCase();
      return lower == '1' || lower == 'true';
    }
    return false;
  }
}
