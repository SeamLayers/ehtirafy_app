import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/backend_contract_status_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContractUnderReviewCard extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ContractUnderReviewCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: ShapeDecoration(
        color: AppColors.success.withValues(alpha: 0.05),
        shadows: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.08),
            blurRadius: 18.r,
            offset: Offset(0, 6.h),
          ),
        ],
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: AppColors.success.withValues(alpha: 0.35),
          ),
          borderRadius: BorderRadius.circular(18.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusHeader(context),
          SizedBox(height: AppSpacing.md),
          _buildServiceInfo(),
          SizedBox(height: AppSpacing.md),
          _buildDetailsCard(context),
        ],
      ),
    );
  }

  Widget _buildStatusHeader(BuildContext context) {
    final isArabic =
        context.locale.languageCode.toLowerCase().startsWith('ar');

    return Row(
      children: [
        Text(
          isArabic ? 'الحالة الحالية' : 'Current Status',
          style: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.textSecondary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.info,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.info.withValues(alpha: 0.25),
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.flag_outlined,
                color: AppColors.textLight,
                size: 12.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                'Initiate',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textLight,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contract.serviceTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.contractPhotographerName.tr(
                  args: [contract.photographerName],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: const LinearGradient(
              begin: Alignment(0.50, 0.00),
              end: Alignment(0.50, 1.00),
              colors: [Color(0xFFC8A44F), Color(0xFFB8944F)],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.30),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Center(
            child: Icon(Icons.camera_alt, color: Colors.white, size: 28.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    final localeCode =
        context.locale.languageCode.toLowerCase().startsWith('ar') ? 'ar' : 'en';

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            AppStrings.contractDateLabel.tr(),
            DateFormat('dd MMMM yyyy - HH:mm a', localeCode).format(
              contract.date,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Divider(height: 1.h, color: AppColors.grey200),
          ),
          _buildDetailRow(
            AppStrings.contractLocationLabel.tr(),
            contract.location,
          ),
          SizedBox(height: AppSpacing.sm),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.07),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.30)),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.contractBudgetLabel.tr(),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textSecondary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Flexible(
                  child: Text(
                    '${contract.budget.toStringAsFixed(0)} ${AppStrings.bookingCurrency.tr()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.primary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.textSecondary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
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

}

class ContractAwaitingPaymentCard extends StatelessWidget {
  final ContractDetailsEntity contract;
  final VoidCallback? onPayPressed;

  const ContractAwaitingPaymentCard({
    super.key,
    required this.contract,
    this.onPayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildTimerCard(),
        SizedBox(height: AppSpacing.md),
        _buildApprovedContent(context),
      ],
    );
  }

  Widget _buildTimerCard() {
    // Calculate time remaining (mock logic: 24 hours from approvedAt)
    // If approvedAt is null, assume just now.
    final approvedTime = contract.approvedAt ?? DateTime.now();
    final deadline = approvedTime.add(const Duration(hours: 24));
    final remaining = deadline.difference(DateTime.now());
    final hours = remaining.inHours.clamp(0, 23);
    final minutes = (remaining.inMinutes % 60).clamp(0, 59);

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.error.withValues(alpha: 0.05),
        border: Border.all(
          color: AppColors.error.withValues(alpha: 0.45),
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withValues(alpha: 0.08),
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.contractPaymentWarningTitle.tr(),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.error,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                Row(
                  children: [
                    _buildTimeUnit(
                      hours.toString().padLeft(2, '0'),
                      AppStrings.hour.tr(),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      ':',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.error,
                        fontSize: 24.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    _buildTimeUnit(
                      minutes.toString().padLeft(2, '0'),
                      AppStrings.minute.tr(),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.sm),
                Text(
                  AppStrings.contractPaymentWarningBody.tr(),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textSecondary,
                    fontSize: 14.sp,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(14.r),
              boxShadow: [
                BoxShadow(
                  color: AppColors.error.withValues(alpha: 0.30),
                  blurRadius: 10.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Icon(Icons.timer, color: Colors.white, size: 24.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeUnit(String value, String label) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          value,
          style: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.error,
            fontSize: 30.sp,
            fontWeight: FontWeight.w800,
          ),
        ),
        SizedBox(width: AppSpacing.xs),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.textSecondary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildApprovedContent(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: ShapeDecoration(
            color: Colors.white, // Or keep transparent if on white bg
            shadows: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 16.r,
                offset: Offset(0, 4.h),
              ),
            ],
            shape: RoundedRectangleBorder(
              side: const BorderSide(color: AppColors.grey200),
              borderRadius: BorderRadius.circular(18.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildApprovedHeader(context),
              SizedBox(height: AppSpacing.md),
              _buildServiceInfo(),
              SizedBox(height: AppSpacing.md),
              _buildDetailsCard(context),
              SizedBox(height: AppSpacing.md),
              _buildPayButton(),
              SizedBox(height: AppSpacing.md),
              _buildSecurityNote(),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md),
        _buildNextStepsCard(),
      ],
    );
  }

  Widget _buildApprovedHeader(BuildContext context) {
    final isArabic =
        context.locale.languageCode.toLowerCase().startsWith('ar');

    return Row(
      children: [
        Text(
          isArabic ? 'الحالة الحالية' : 'Current Status',
          style: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.textSecondary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: AppColors.success,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.success.withValues(alpha: 0.25),
                blurRadius: 8.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.verified_outlined,
                color: AppColors.textLight,
                size: 12.sp,
              ),
              SizedBox(width: 4.w),
              Text(
                'Approved',
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textLight,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildServiceInfo() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contract.serviceTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w700,
                  height: 1.3,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.contractPhotographerName.tr(
                  args: [contract.photographerName],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            gradient: const LinearGradient(
              begin: Alignment(0.50, 0.00),
              end: Alignment(0.50, 1.00),
              colors: [Color(0xFFC8A44F), Color(0xFFB8944F)],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.30),
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Center(
            child: Icon(Icons.camera_alt, color: Colors.white, size: 28.sp),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsCard(BuildContext context) {
    final localeCode =
        context.locale.languageCode.toLowerCase().startsWith('ar') ? 'ar' : 'en';

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        border: Border.all(color: AppColors.grey200),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            AppStrings.contractDateLabel.tr(),
            DateFormat('dd MMMM yyyy - HH:mm a', localeCode).format(
              contract.date,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: Divider(height: 1.h, color: AppColors.grey200),
          ),
          _buildDetailRow(
            AppStrings.contractLocationLabel.tr(),
            contract.location,
          ),
          SizedBox(height: AppSpacing.sm),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.07),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.30)),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  AppStrings.contractBudgetLabel.tr(),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textSecondary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Flexible(
                  child: Text(
                    '${contract.budget.toStringAsFixed(0)} ${AppStrings.bookingCurrency.tr()}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.primary,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.textSecondary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
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

  Widget _buildPayButton() {
    return GestureDetector(
      onTap: onPayPressed,
      child: Container(
        width: double.infinity,
        height: 52.h,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFC8A44F), Color(0xFFB8944F)],
          ),
          borderRadius: BorderRadius.circular(14.r),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.35),
              blurRadius: 14.r,
              offset: Offset(0, 6.h),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.lock_outline,
                color: Colors.white,
                size: 18.sp,
              ),
              SizedBox(width: AppSpacing.sm),
              Text(
                AppStrings.contractPayNowAction.tr(),
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityNote() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.info.withValues(alpha: 0.10),
        border: Border.all(color: AppColors.info.withValues(alpha: 0.25)),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Row(
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            decoration: BoxDecoration(
              color: AppColors.info.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(Icons.security, color: AppColors.info, size: 18.sp),
          ),
          SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              AppStrings.contractPaymentSecurityNote.tr(),
              style: TextStyle(
                fontFamily: 'Cairo',
                color: AppColors.textSecondary,
                fontSize: 12.sp,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNextStepsCard() {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.grey200),
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.checklist_rtl_outlined,
                color: AppColors.gold,
                size: 18.sp,
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  AppStrings.contractWhatHappensAfterPayment.tr(),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          _buildStepItem('1', AppStrings.contractStep1Confirm.tr()),
          SizedBox(height: AppSpacing.md),
          _buildStepItem('2', AppStrings.contractStep2Prepare.tr()),
          SizedBox(height: AppSpacing.md),
          _buildStepItem('3', AppStrings.contractStep3Contact.tr()),
        ],
      ),
    );
  }

  Widget _buildStepItem(String number, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 26.w,
          height: 26.w,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFFC8A44F), Color(0xFFB8944F)],
            ),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.25),
                blurRadius: 6.r,
                offset: Offset(0, 2.h),
              ),
            ],
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                fontFamily: 'Cairo',
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              height: 1.45,
            ),
          ),
        ),
      ],
    );
  }
}

class ContractInProgressActions extends StatelessWidget {
  final VoidCallback? onCompletePressed;

  const ContractInProgressActions({
    super.key,
    this.onCompletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 52.h,
          child: ElevatedButton.icon(
            onPressed: onCompletePressed,
            icon: Icon(Icons.check_circle_outline, size: 18.sp),
            label: Text(
              AppStrings.contractFinishService.tr(),
              style: TextStyle(
                fontFamily: 'Cairo',
                fontSize: 14.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              foregroundColor: Colors.white,
              elevation: 0,
              shadowColor: AppColors.success.withValues(alpha: 0.3),
            ),
          ),
        ),
      ],
    );
  }
}

class ContractThreeStatusCard extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ContractThreeStatusCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStatusRow(
            context,
            AppStrings.contractStatusGeneralLabel.tr(),
            contract.contractStatus ?? contract.status.name,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(
    BuildContext context,
    String label,
    String? statusValue,
  ) {
    final isArabic =
        context.locale.languageCode.toLowerCase().startsWith('ar');
    final canonical = canonicalBackendContractStatus(statusValue);
    final ui = backendContractStatusUi(canonical);
    final subtitle = backendStatusSubtitle(canonical, isArabic: isArabic);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Container(
          constraints: BoxConstraints(maxWidth: 210.w),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: ui.softColor,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: ui.color.withValues(alpha: 0.35)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: ui.color.withValues(alpha: 0.18),
                  borderRadius: BorderRadius.circular(8.r),
                ),
                child: Icon(ui.icon, size: 14.sp, color: ui.color),
              ),
              SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      canonical,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: ui.color,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.textSecondary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
