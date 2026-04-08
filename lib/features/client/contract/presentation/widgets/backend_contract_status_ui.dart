import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class BackendContractStatusUi {
  final Color color;
  final Color softColor;
  final IconData icon;

  const BackendContractStatusUi({
    required this.color,
    required this.softColor,
    required this.icon,
  });
}

String canonicalBackendContractStatus(String? rawStatus) {
  final normalized = rawStatus?.trim().toLowerCase() ?? '';

  switch (normalized) {
    case 'initiate':
    case 'initiated':
      return 'Initiate';
    case 'approved':
      return 'Approved';
    case 'inprogress':
    case 'inprocess':
    case 'in_progress':
    case 'active':
      return 'InProgress';
    case 'completed':
    case 'closed':
      return 'Closed';
    case 'rejected':
      return 'Rejected';
    case 'cancelled':
    case 'canceled':
      return 'Cancelled';
    default:
      if (rawStatus == null || rawStatus.trim().isEmpty) {
        return 'Initiate';
      }
      return rawStatus;
  }
}

BackendContractStatusUi backendContractStatusUi(String canonicalStatus) {
  switch (canonicalStatus) {
    case 'Initiate':
      return const BackendContractStatusUi(
        color: Color(0xFF0EA5E9),
        softColor: Color(0xFFE0F2FE),
        icon: Icons.flag_outlined,
      );
    case 'Approved':
      return const BackendContractStatusUi(
        color: Color(0xFF22C55E),
        softColor: Color(0xFFDCFCE7),
        icon: Icons.verified_outlined,
      );
    case 'InProgress':
      return const BackendContractStatusUi(
        color: Color(0xFFC8A44F),
        softColor: Color(0xFFFFF7E6),
        icon: Icons.timelapse_outlined,
      );
    case 'Closed':
      return const BackendContractStatusUi(
        color: AppColors.success,
        softColor: Color(0xFFE8F5E9),
        icon: Icons.task_alt_outlined,
      );
    case 'Rejected':
      return const BackendContractStatusUi(
        color: AppColors.error,
        softColor: Color(0xFFFDECEC),
        icon: Icons.block_outlined,
      );
    case 'Cancelled':
      return const BackendContractStatusUi(
        color: AppColors.error,
        softColor: Color(0xFFFDECEC),
        icon: Icons.cancel_outlined,
      );
    default:
      return const BackendContractStatusUi(
        color: AppColors.grey500,
        softColor: Color(0xFFF5F5F5),
        icon: Icons.info_outline,
      );
  }
}

String backendStatusSubtitle(
  String canonicalStatus, {
  required bool isArabic,
}) {
  switch (canonicalStatus) {
    case 'Initiate':
      return isArabic
          ? 'تم إنشاء العقد وبانتظار موافقة المصور'
          : 'Contract created and waiting for freelancer approval';
    case 'Approved':
      return isArabic
          ? 'تمت الموافقة، والخطوة التالية هي بدء التنفيذ'
          : 'Approved successfully, next step is starting execution';
    case 'InProgress':
      return isArabic
          ? 'العقد قيد التنفيذ حالياً'
          : 'Contract is currently in progress';
    case 'Closed':
      return isArabic
          ? 'العقد أُغلق بعد اكتمال التنفيذ'
          : 'Contract is closed after completion';
    case 'Rejected':
      return isArabic ? 'تم رفض العقد من طرف المصور' : 'Contract was rejected';
    case 'Cancelled':
      return isArabic ? 'تم إلغاء العقد' : 'Contract was cancelled';
    default:
      return isArabic
          ? 'حالة العقد محدثة من الخادم'
          : 'Contract status synced from backend';
  }
}

String localizedContractStatusFontFamily(BuildContext context) {
  final isArabic =
      Localizations.localeOf(context).languageCode.toLowerCase().startsWith(
            'ar',
          );
  return isArabic ? 'Cairo' : 'Roboto';
}
