import 'package:equatable/equatable.dart';

/// Enum for contract status mapping from API to UI
enum ContractStatus {
  pending,
  accepted,
  rejected,
  completed,
  cancelled,
  awaitingPayment;

  /// Get Arabic display name for UI badges
  String get displayName {
    switch (this) {
      case ContractStatus.pending:
        return 'قيد الانتظار';
      case ContractStatus.accepted:
        return 'مقبول';
      case ContractStatus.rejected:
        return 'مرفوض';
      case ContractStatus.completed:
        return 'مكتمل';
      case ContractStatus.cancelled:
        return 'ملغي';
      case ContractStatus.awaitingPayment:
        return 'بانتظار الدفع';
    }
  }

  /// Parse from API string value
  static ContractStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'accepted':
        return ContractStatus.accepted;
      case 'rejected':
        return ContractStatus.rejected;
      case 'completed':
        return ContractStatus.completed;
      case 'cancelled':
        return ContractStatus.cancelled;
      default:
        return ContractStatus.pending;
    }
  }
}

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
  /// Priority: rejected > cancelled > completed > accepted > pending
  /// Get the combined status for display
  /// Flow:
  /// 1. Rejected -> Rejected
  /// 2. Cancelled -> Cancelled
  /// 3. Completed -> Completed
  /// 4. Freelancer Approved + Customer Initiated -> Awaiting Payment (Freelancer approved but client needs to pay)
  /// 5. Freelancer Approved + Customer Paid/InProcess -> In Progress (Active)
  /// 6. Freelancer Approved -> Accepted (Fallback)
  /// 7. Default -> Pending
  ContractStatus get displayStatus {
    final pubStatus = contrPubStatus?.toLowerCase();
    final custStatus = contrCustStatus?.toLowerCase();

    if (pubStatus == 'rejected') return ContractStatus.rejected;
    if (custStatus == 'cancelled') return ContractStatus.cancelled;

    // Check for completed
    if (pubStatus == 'completed' ||
        custStatus == 'completed' ||
        contractStatus?.toLowerCase() == 'closed') {
      return ContractStatus.completed;
    }

    // Check for "Approved" flow
    if (pubStatus == 'approved') {
      // If customer status is 'initiated' or null, it means they haven't paid yet
      // So it is Awaiting Payment (which we map to accepted/awaitingPayment in UI logic,
      // but here we might need a specific status if the Enum supports it.
      // The Enum currently has: pending, accepted, rejected, completed, cancelled.
      // We often map 'Awaiting Payment' to a specific UI state.
      // Let's see how ContractStatus is used.

      // If the customer has paid (InProcess/Paid), it's fully Accepted/Active
      if (custStatus == 'inprocess' ||
          custStatus == 'paid' ||
          custStatus == 'approved') {
        return ContractStatus
            .accepted; // This maps to "In Progress" in many UI checks
      }

      // If customer hasn't paid yet (Initiated)
      // We might need to return 'accepted' but the UI needs to know it's awaiting payment.
      // OR, we update the Enum. The user wants strict cases.
      // Looking at `ContractDetailsScreen`:
      // if (contract.status == ContractStatus.awaitingPayment)
      // The Enum in `contract_details_entity.dart` has `awaitingPayment`.
      // BUT `contract_entity.dart` Enum DOES NOT have `awaitingPayment`.
      // I should align them or map carefully.

      // For ContractEntity (List View), usually "Accepted" covers both, or "Pending".
      // Let's check ContractEntity Enum again.
      // Enum: pending, accepted, rejected, completed, cancelled.
      // If I want to show "Awaiting Payment" in the list, I might need to add it to Enum
      // OR use 'accepted' and let the UI distinct.
      // However, the prompt implies strict flow.
      // For the LIST view, 'Accepted' usually implies Active.
      // If it's awaiting payment, it might be better to treat as 'Pending' or a new status.
      // Let's add 'awaitingPayment' to ContractEntity's Enum to be safe and consistent.
      return ContractStatus.awaitingPayment;
    }

    return ContractStatus.pending;
  }

  /// Check if chat is allowed for this contract
  /// Rule: Chat is allowed only when contract is ACCEPTED (in progress)
  /// Chat is NOT allowed when: pending, rejected, cancelled, or completed
  bool get isChatAllowed {
    final status = displayStatus;
    return status == ContractStatus.accepted;
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
