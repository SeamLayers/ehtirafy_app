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

  // Status fields
  final String?
  contractStatus; // Overall contract status (Initial, InProcess, Closed)
  final String?
  contrPubStatus; // Photographer's status (accepted/rejected/completed)
  final String? contrCustStatus; // Client's status (cancelled/completed)

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
    this.contrPubStatus,
    this.contrCustStatus,
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
  /// API reality (verified via live testing):
  /// - contract_status: 'initiated' → 'InProcess' (auto on Paid) → 'Completed' (auto when both complete)
  /// - contr_pub_status: 'pending' → 'Approved' (freelancer accepts) → 'Completed' (freelancer delivers)
  /// - contr_cust_status: 'initiated' → 'Paid' (customer pays) → 'Completed' (customer confirms)
  ContractStatus get displayStatus {
    final status = contractStatus?.toLowerCase();
    final pubStatus = contrPubStatus?.toLowerCase();
    final custStatus = contrCustStatus?.toLowerCase();

    // Completed (both parties confirmed)
    if (status == 'completed' || status == 'closed') {
      return ContractStatus.completed;
    }

    // Rejected by freelancer
    if (pubStatus == 'rejected') return ContractStatus.rejected;

    // Cancelled by customer
    if (custStatus == 'cancelled') return ContractStatus.cancelled;

    // In process (auto-set when customer pays)
    if (status == 'inprocess') {
      // Freelancer delivered, waiting for customer confirmation
      if (pubStatus == 'completed' && custStatus != 'completed') {
        return ContractStatus.awaitingAdminReview;
      }
      return ContractStatus.inProgress;
    }

    // Freelancer accepted (contract_status=Approved from backend)
    if (status == 'approved') {
      return ContractStatus.pendingPayment;
    }

    // Initiated state
    if (status == 'initiated') {
      // Freelancer accepted, waiting for customer payment
      if (pubStatus == 'approved') {
        return ContractStatus.pendingPayment;
      }
      return ContractStatus.initiated;
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
    contrPubStatus,
    contrCustStatus,
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
