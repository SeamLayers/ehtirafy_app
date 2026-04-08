import 'package:easy_localization/easy_localization.dart';
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
    final isArabic =
        context.locale.languageCode.toLowerCase().startsWith('ar');

    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: ShapeDecoration(
            color: const Color(0x0C28A745),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: AppColors.success),
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildStatusHeader(context),
              SizedBox(height: 16.h),
              _buildServiceInfo(),
              SizedBox(height: 16.h),
              _buildDetailsCard(context),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        _buildNextStepsCard(isArabic: isArabic),
      ],
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
            color: AppColors.grey500,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: const Color(0xFF17A2B8),
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            'Initiate',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
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
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                AppStrings.contractPhotographerName.tr(
                  args: [contract.photographerName],
                ),
                style: TextStyle(
                  color: AppColors.grey500,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            gradient: const LinearGradient(
              begin: Alignment(0.50, 0.00),
              end: Alignment(0.50, 1.00),
              colors: [Color(0xFFC8A44F), Color(0xFFB8944F)],
            ),
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
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            AppStrings.contractDateLabel.tr(),
            DateFormat('dd MMMM yyyy - HH:mm a', localeCode).format(
              contract.date,
            ),
          ),
          SizedBox(height: 8.h),
          _buildDetailRow(
            AppStrings.contractLocationLabel.tr(),
            contract.location,
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey200),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    AppStrings.contractBudgetLabel.tr(),
                    style: TextStyle(color: AppColors.grey500, fontSize: 14.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    '${contract.budget.toStringAsFixed(0)} ${AppStrings.bookingCurrency.tr()}',
                    style: TextStyle(
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.grey500, fontSize: 14.sp),
        ),
        Text(
          value,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp),
        ),
      ],
    );
  }

  Widget _buildNextStepsCard({required bool isArabic}) {
    final steps = [
      isArabic
          ? 'Initiate: تم إنشاء العقد وبانتظار موافقة المصور.'
          : 'Initiate: The contract was created and is awaiting freelancer approval.',
      isArabic
          ? 'Approved: بعد الموافقة ينتقل العقد إلى InProgress.'
          : 'Approved: After approval, the contract moves to InProgress.',
      isArabic
          ? 'InProgress: أثناء تنفيذ الخدمة حتى تأكيد الإغلاق.'
          : 'InProgress: Service is being delivered until closure confirmation.',
      isArabic
          ? 'Closed: الحالة النهائية بعد إكمال الخدمة.'
          : 'Closed: Final state after service completion.',
    ];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.grey200),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic
                ? 'تسلسل الحالة (Backend Flow)'
                : 'Status Sequence (Backend Flow)',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 12.h),
          _buildStepItem('1', steps[0]),
          SizedBox(height: 12.h),
          _buildStepItem('2', steps[1]),
          SizedBox(height: 12.h),
          _buildStepItem('3', steps[2]),
          SizedBox(height: 12.h),
          _buildStepItem('4', steps[3]),
        ],
      ),
    );
  }

  Widget _buildStepItem(String number, String text) {
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: AppColors.grey500, fontSize: 14.sp),
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
        SizedBox(height: 16.h),
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
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: const Color(0x0CDC3545),
        border: Border.all(color: AppColors.error, width: 2),
        borderRadius: BorderRadius.circular(14.r),
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
                    color: AppColors.error,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 8.h),
                Row(
                  children: [
                    _buildTimeUnit(
                      hours.toString().padLeft(2, '0'),
                      AppStrings.hour.tr(),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      ':',
                      style: TextStyle(color: AppColors.error, fontSize: 20.sp),
                    ),
                    SizedBox(width: 8.w),
                    _buildTimeUnit(
                      minutes.toString().padLeft(2, '0'),
                      AppStrings.minute.tr(),
                    ),
                  ],
                ),
                SizedBox(height: 8.h),
                Text(
                  AppStrings.contractPaymentWarningBody.tr(),
                  style: TextStyle(
                    color: AppColors.grey500,
                    fontSize: 14.sp,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppColors.error,
              borderRadius: BorderRadius.circular(14.r),
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
            color: AppColors.error,
            fontSize: 30.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          label,
          style: TextStyle(color: AppColors.grey500, fontSize: 16.sp),
        ),
      ],
    );
  }

  Widget _buildApprovedContent(BuildContext context) {
    return Column(
      children: [
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(16.w),
          decoration: ShapeDecoration(
            color: Colors.white, // Or keep transparent if on white bg
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14.r),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildApprovedHeader(context),
              SizedBox(height: 16.h),
              _buildServiceInfo(),
              SizedBox(height: 16.h),
              _buildDetailsCard(context),
              SizedBox(height: 16.h),
              _buildPayButton(),
              SizedBox(height: 16.h),
              _buildSecurityNote(),
            ],
          ),
        ),
        SizedBox(height: 16.h),
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
            color: AppColors.grey500,
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: 8.w),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
          decoration: BoxDecoration(
            color: AppColors.success,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            'Approved',
            style: TextStyle(
              color: AppColors.textLight,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
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
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                AppStrings.contractPhotographerName.tr(
                  args: [contract.photographerName],
                ),
                style: TextStyle(
                  color: AppColors.grey500,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 56.w,
          height: 56.w,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            gradient: const LinearGradient(
              begin: Alignment(0.50, 0.00),
              end: Alignment(0.50, 1.00),
              colors: [Color(0xFFC8A44F), Color(0xFFB8944F)],
            ),
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
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.grey200),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Column(
        children: [
          _buildDetailRow(
            AppStrings.contractDateLabel.tr(),
            DateFormat('dd MMMM yyyy - HH:mm a', localeCode).format(
              contract.date,
            ),
          ),
          SizedBox(height: 8.h),
          _buildDetailRow(
            AppStrings.contractLocationLabel.tr(),
            contract.location,
          ),
          SizedBox(height: 8.h),
          Container(
            padding: EdgeInsets.symmetric(vertical: 4.h),
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.grey200),
              borderRadius: BorderRadius.circular(4.r),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    AppStrings.contractBudgetLabel.tr(),
                    style: TextStyle(color: AppColors.grey500, fontSize: 14.sp),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.w),
                  child: Text(
                    '${contract.budget.toStringAsFixed(0)} ${AppStrings.bookingCurrency.tr()}',
                    style: TextStyle(
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
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(color: AppColors.grey500, fontSize: 14.sp),
        ),
        Text(
          value,
          style: TextStyle(color: AppColors.textPrimary, fontSize: 14.sp),
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    return GestureDetector(
      onTap: onPayPressed,
      child: Container(
        width: double.infinity,
        height: 48.h,
        decoration: BoxDecoration(
          color: AppColors.primary,
          borderRadius: BorderRadius.circular(14.r),
        ),
        child: Center(
          child: Text(
            AppStrings.contractPayNowAction.tr(),
            style: TextStyle(
              color: Colors.white,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSecurityNote() {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0x1917A2B8),
        border: Border.all(color: const Color(0x3316A2B8)),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              AppStrings.contractPaymentSecurityNote.tr(),
              style: TextStyle(color: AppColors.grey500, fontSize: 12.sp),
            ),
          ),
          Icon(Icons.security, color: const Color(0xFF17A2B8), size: 16.sp),
        ],
      ),
    );
  }

  Widget _buildNextStepsCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.grey200),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.contractWhatHappensAfterPayment.tr(),
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 12.h),
          _buildStepItem('1', AppStrings.contractStep1Confirm.tr()),
          SizedBox(height: 12.h),
          _buildStepItem('2', AppStrings.contractStep2Prepare.tr()),
          SizedBox(height: 12.h),
          _buildStepItem('3', AppStrings.contractStep3Contact.tr()),
        ],
      ),
    );
  }

  Widget _buildStepItem(String number, String text) {
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.w,
          decoration: const BoxDecoration(
            color: AppColors.primary,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(color: Colors.white, fontSize: 12.sp),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(color: AppColors.grey500, fontSize: 14.sp),
          ),
        ),
      ],
    );
  }
}

class ContractInProgressActions extends StatelessWidget {
  final VoidCallback? onChatPressed;
  final VoidCallback? onCompletePressed;

  const ContractInProgressActions({
    super.key,
    this.onChatPressed,
    this.onCompletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: OutlinedButton(
            onPressed: onChatPressed,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primary, width: 2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              foregroundColor: AppColors.primary,
            ),
            child: Text(
              AppStrings.contractContactPhotographer.tr(),
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          height: 48.h,
          child: ElevatedButton(
            onPressed: onCompletePressed,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.success,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              foregroundColor: Colors.white,
              elevation: 0,
            ),
            child: Text(
              AppStrings.contractFinishService.tr(),
              style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
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
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
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
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Container(
          constraints: BoxConstraints(maxWidth: 210.w),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          decoration: BoxDecoration(
            color: ui.softColor,
            borderRadius: BorderRadius.circular(10.r),
            border: Border.all(color: ui.color.withValues(alpha: 0.35)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(ui.icon, size: 14.sp, color: ui.color),
              SizedBox(width: 6.w),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      canonical,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
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
