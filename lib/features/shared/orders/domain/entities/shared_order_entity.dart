import 'package:equatable/equatable.dart';

import 'package:ehtirafy_app/features/shared/contracts/domain/entities/contract_status.dart';

enum SharedOrderStatus {
  pending,
  pendingPayment,
  awaitingAdminReview,
  inProgress,
  completed,
  cancelled,
  archived,
}

class SharedOrderEntity extends Equatable {
  final String id;
  final String serviceTitle;
  final String counterpartyName;
  final String counterpartyImage;
  final String counterpartyId;
  final String advertisementId;
  final SharedOrderStatus status;
  final double price;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final bool isPaymentRequired;
  final DateTime? approvedDate;

  const SharedOrderEntity({
    required this.id,
    required this.serviceTitle,
    required this.counterpartyName,
    required this.counterpartyImage,
    required this.counterpartyId,
    required this.advertisementId,
    required this.status,
    required this.price,
    required this.createdAt,
    this.updatedAt,
    this.isPaymentRequired = false,
    this.approvedDate,
  });

  static SharedOrderStatus fromContractStatus(ContractStatus status) {
    switch (status) {
      case ContractStatus.pending:
        return SharedOrderStatus.pending;
      case ContractStatus.pendingPayment:
        return SharedOrderStatus.pendingPayment;
      case ContractStatus.awaitingAdminReview:
        return SharedOrderStatus.awaitingAdminReview;
      case ContractStatus.inProgress:
        return SharedOrderStatus.inProgress;
      case ContractStatus.completed:
        return SharedOrderStatus.completed;
      case ContractStatus.cancelled:
      case ContractStatus.rejected:
        return SharedOrderStatus.cancelled;
      case ContractStatus.archived:
        return SharedOrderStatus.archived;
    }
  }

  @override
  List<Object?> get props => [
    id,
    serviceTitle,
    counterpartyName,
    counterpartyImage,
    counterpartyId,
    advertisementId,
    status,
    price,
    createdAt,
    updatedAt,
    isPaymentRequired,
    approvedDate,
  ];
}
