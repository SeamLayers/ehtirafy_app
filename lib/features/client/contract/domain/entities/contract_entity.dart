import 'package:equatable/equatable.dart';
import 'package:ehtirafy_app/features/shared/contracts/domain/entities/contract_status.dart';

export 'package:ehtirafy_app/features/shared/contracts/domain/entities/contract_status.dart';

class ContractEntity extends Equatable {
  final int id;
  final String advertisementId;

  // App-friendly naming (mapped from API's freelancer/customer)
  final String photographerId; // Maps from publisher_id (freelancer)
  final String clientId; // Maps from customer_id

  final String requestedAmount;
  final String actualAmount;

  // Single backend status field
  final String? contractStatus;

  final DateTime createdAt;
  final DateTime updatedAt;

  // Display fields for lists
  final String? serviceTitle;
  final String? photographerName;
  final String? photographerImage;
  final String? clientName;
  final String? clientImage;

  // Chat messages embedded in contract (if present)
  final List<Map<String, dynamic>>? chatMessages;

  const ContractEntity({
    required this.id,
    required this.advertisementId,
    required this.photographerId,
    required this.clientId,
    required this.requestedAmount,
    required this.actualAmount,
    this.contractStatus,
    required this.createdAt,
    required this.updatedAt,
    this.serviceTitle,
    this.photographerName,
    this.photographerImage,
    this.clientName,
    this.clientImage,
    this.chatMessages,
  });

  /// Get the combined status for display
  ///
  /// Current backend flow:
  /// - initiated -> opened (auto) -> inProgress (after freelancer approval) -> completed
  ContractStatus get displayStatus {
    final status = contractStatus?.toLowerCase();

    if (status == 'completed' || status == 'closed') {
      return ContractStatus.completed;
    }

    if (status == 'rejected') {
      return ContractStatus.rejected;
    }

    if (status == 'cancelled') {
      return ContractStatus.cancelled;
    }

    if (status == 'archived') {
      return ContractStatus.archived;
    }

    if (status == 'inprocess' ||
        status == 'inprogress' ||
        status == 'in_progress' ||
        status == 'active' ||
        status == 'approved') {
      return ContractStatus.inProgress;
    }

    if (status == 'initiate' || status == 'initiated') {
      return ContractStatus.initiated;
    }

    if (status == 'opened' || status == 'open' || status == 'pending') {
      return ContractStatus.pending;
    }

    return ContractStatus.pending;
  }

  /// Check if chat is allowed for this contract
  /// Chat is allowed when contract is active (initiated, pending, in progress, or completed)
  /// Chat is NOT allowed for: cancelled, rejected, archived
  bool get isChatAllowed {
    final status = displayStatus;
    return status == ContractStatus.initiated ||
        status == ContractStatus.pending ||
        status == ContractStatus.pendingPayment ||
        status == ContractStatus.inProgress ||
        status == ContractStatus.awaitingAdminReview ||
        status == ContractStatus.completed;
  }

  @override
  List<Object?> get props => [
    id,
    advertisementId,
    photographerId,
    clientId,
    requestedAmount,
    actualAmount,
    contractStatus,
    createdAt,
    updatedAt,
    serviceTitle,
    photographerName,
    photographerImage,
    clientName,
    clientImage,
    chatMessages,
  ];
}
