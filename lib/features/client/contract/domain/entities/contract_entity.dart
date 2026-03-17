import 'package:equatable/equatable.dart';

/// Enum for contract status mapping from API to UI
enum ContractStatus {
  pending,               // Freelancer hasn't accepted yet
  pendingPayment,        // Freelancer accepted, waiting for customer payment
  awaitingAdminReview,   // Payment proof submitted, awaiting admin verification
  inProgress,            // Admin approved payment, contract is active
  completed,
  cancelled,
  rejected,
  archived;

  /// Get Arabic display name for UI badges
  String get displayName {
    switch (this) {
      case ContractStatus.pending:
        return 'قيد الانتظار';
      case ContractStatus.pendingPayment:
        return 'بانتظار الدفع';
      case ContractStatus.awaitingAdminReview:
        return 'بانتظار تحقق الإدارة';
      case ContractStatus.inProgress:
        return 'جاري التنفيذ';
      case ContractStatus.completed:
        return 'مكتمل';
      case ContractStatus.cancelled:
        return 'ملغي';
      case ContractStatus.rejected:
        return 'مرفوض';
      case ContractStatus.archived:
        return 'مؤرشف';
    }
  }

  /// Parse from API string value
  static ContractStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'pending':
        return ContractStatus.pending;
      case 'pendingpayment':
      case 'pending_payment':
      case 'awaiting_payment':
        return ContractStatus.pendingPayment;
      case 'awaitingadminreview':
      case 'awaiting_admin_review':
      case 'underreview':
      case 'under_review':
        return ContractStatus.awaitingAdminReview;
      case 'inprogress':
      case 'in_progress':
      case 'active':
        return ContractStatus.inProgress;
      case 'completed':
        return ContractStatus.completed;
      case 'cancelled':
        return ContractStatus.cancelled;
      case 'rejected':
        return ContractStatus.rejected;
      case 'archived':
        return ContractStatus.archived;
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
      // If customer status is 'inprocess' or 'paid', payment was successful
      if (custStatus == 'inprocess' ||
          custStatus == 'paid' ||
          custStatus == 'approved') {
        return ContractStatus.inProgress;
      }

      // If customer hasn't paid yet (Initiated)
      return ContractStatus.pendingPayment;
    }

    return ContractStatus.pending;
  }

  /// Check if chat is allowed for this contract
  /// Rule: Chat is allowed only when contract is IN_PROGRESS
  /// Chat is NOT allowed when: pending, pendingPayment, awaitingAdminReview, rejected, cancelled, or completed
  bool get isChatAllowed {
    final status = displayStatus;
    return status == ContractStatus.inProgress;
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
