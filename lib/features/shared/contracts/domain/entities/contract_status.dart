enum ContractStatus {
  initiated,
  pending,
  pendingPayment,
  awaitingAdminReview,
  inProgress,
  completed,
  cancelled,
  rejected,
  archived,
}

extension ContractStatusPresentation on ContractStatus {
  String get displayName {
    switch (this) {
      case ContractStatus.initiated:
        return 'تم الإنشاء';
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
}

class ContractStatusMapper {
  static ContractStatus fromString(String? value) {
    switch (value?.toLowerCase()) {
      case 'initiate':
      case 'initiated':
        return ContractStatus.initiated;
      case 'opened':
      case 'open':
      case 'pending':
        return ContractStatus.pending;
      case 'approved':
      case 'pendingpayment':
      case 'pending_payment':
      case 'awaiting_payment':
      case 'awaitingadminreview':
      case 'awaiting_admin_review':
      case 'underreview':
      case 'under_review':
        return ContractStatus.inProgress;
      case 'inprogress':
      case 'inprocess':
      case 'in_progress':
      case 'active':
        return ContractStatus.inProgress;
      case 'completed':
      case 'closed':
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