import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/backend_contract_status_ui.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/contract_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsCancelledView extends StatelessWidget {
  final ContractDetailsEntity contract;

  const OrderDetailsCancelledView({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    final isArabic =
        context.locale.languageCode.toLowerCase().startsWith('ar');

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContractHeader(contract: contract),
          SizedBox(height: AppSpacing.md),
          _buildCancelledMessage(context, isArabic: isArabic),
          SizedBox(height: AppSpacing.md),
          _buildSummaryCard(context, isArabic: isArabic),
        ],
      ),
    );
  }

  Widget _buildCancelledMessage(
    BuildContext context, {
    required bool isArabic,
  }) {
    final isRejected = contract.status == ContractStatus.rejected;
    final canonical = canonicalBackendContractStatus(
      contract.contractStatus ?? contract.status.name,
    );
    final ui = backendContractStatusUi(canonical);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg - AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ui.color.withValues(alpha: 0.10),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: ui.color.withValues(alpha: 0.30)),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 18,
            offset: Offset(0, 6),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        children: [
          // Large rounded closed emblem derived from backend status.
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              color: ui.softColor,
              shape: BoxShape.circle,
              border: Border.all(
                color: ui.color.withValues(alpha: 0.30),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: ui.color.withValues(alpha: 0.15),
                  blurRadius: 14,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Icon(
              ui.icon,
              color: ui.color,
              size: 40.sp,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            isRejected
                ? (isArabic ? 'مرفوض' : 'Rejected')
                : (isArabic ? 'ملغي' : 'Cancelled'),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: ui.color,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            isRejected
                ? (isArabic
                      ? 'تم رفض العقد من طرف المصور.'
                      : 'The contract was rejected by the freelancer.')
                : (isArabic
                      ? 'تم إلغاء العقد.'
                      : 'The contract was cancelled.'),
            style: TextStyle(
              fontFamily: 'Cairo',
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  /// Compact contract summary (date / location / budget) for the closed state.
  Widget _buildSummaryCard(BuildContext context, {required bool isArabic}) {
    final localeCode = isArabic ? 'ar' : 'en';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16,
            offset: Offset(0, 6),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow(
            icon: Icons.event_rounded,
            label: AppStrings.contractDateLabel.tr(),
            value: DateFormat('dd MMMM yyyy', localeCode).format(contract.date),
          ),
          _summaryDivider(),
          _buildSummaryRow(
            icon: Icons.place_rounded,
            label: AppStrings.contractLocationLabel.tr(),
            value: contract.location,
          ),
          _summaryDivider(),
          _buildSummaryRow(
            icon: Icons.payments_rounded,
            label: AppStrings.contractBudgetLabel.tr(),
            value:
                '${contract.budget.toStringAsFixed(0)} ${AppStrings.bookingCurrency.tr()}',
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: const BoxDecoration(
            color: AppColors.grey100,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.textSecondary, size: 18.sp),
        ),
        SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.textSecondary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _summaryDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: const Divider(height: 1, color: AppColors.grey200),
    );
  }
}
