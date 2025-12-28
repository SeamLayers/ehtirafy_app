import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContractUnderReviewCard extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ContractUnderReviewCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
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
              _buildStatusHeader(),
              SizedBox(height: 16.h),
              _buildServiceInfo(),
              SizedBox(height: 16.h),
              _buildDetailsCard(),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        _buildNextStepsCard(),
      ],
    );
  }

  Widget _buildStatusHeader() {
    return Row(
      children: [
        Text(
          AppStrings.contractStatusUnderReview.tr(),
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
            AppStrings.contractStatusUnderReviewBadge.tr(),
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

  Widget _buildDetailsCard() {
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
            DateFormat('dd MMMM yyyy - HH:mm a', 'ar').format(contract.date),
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
            AppStrings.contractWhatHappensNext.tr(),
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          SizedBox(height: 12.h),
          _buildStepItem('1', AppStrings.contractStep1Payment.tr()),
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
        _buildApprovedContent(),
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

  Widget _buildApprovedContent() {
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
              _buildApprovedHeader(),
              SizedBox(height: 16.h),
              _buildServiceInfo(),
              SizedBox(height: 16.h),
              _buildDetailsCard(),
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

  Widget _buildApprovedHeader() {
    return Row(
      children: [
        Text(
          AppStrings.contractPhotographerApprovedTitle.tr(),
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
            AppStrings.contractApprovedBadge.tr(),
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

  Widget _buildDetailsCard() {
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
            DateFormat('dd MMMM yyyy - HH:mm a', 'ar').format(contract.date),
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
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildStatusRow(
            AppStrings.contractStatusGeneralLabel.tr(),
            contract.contractStatus,
          ),
          Divider(height: 16.h, thickness: 1, color: AppColors.grey200),
          _buildStatusRow(
            AppStrings.contractStatusFreelancerLabel.tr(),
            contract.contrPubStatus,
          ),
          Divider(height: 16.h, thickness: 1, color: AppColors.grey200),
          _buildStatusRow(
            AppStrings.contractStatusCustomerLabel.tr(),
            contract.contrCustStatus,
          ),
        ],
      ),
    );
  }

  Widget _buildStatusRow(String label, String? statusValue) {
    // Determine color and display text based on status value (case-insensitive checks)
    Color statusColor = AppColors.grey500;
    String displayText = statusValue ?? 'N/A';
    final val = statusValue?.toLowerCase() ?? '';

    if (val == 'initial' || val == 'pending') {
      statusColor = Colors.orange;
      displayText = AppStrings.contractValInitial.tr();
    } else if (val == 'inprocess' ||
        val == 'inprogress' ||
        val == 'approved' ||
        val == 'active') {
      statusColor = AppColors.primary;
      // If specific "Approved" check
      if (val == 'approved') {
        displayText = AppStrings.contractValApproved.tr();
      } else {
        displayText = AppStrings.contractValInProcess.tr();
      }
    } else if (val == 'completed' || val == 'closed' || val == 'paid') {
      statusColor = AppColors.success;
      if (val == 'closed') {
        displayText = AppStrings.contractValClosed.tr();
      } else if (val == 'paid') {
        displayText = AppStrings.contractValPaid.tr();
      } else {
        displayText = AppStrings.contractValCompleted.tr();
      }
    } else if (val == 'rejected' || val == 'cancelled') {
      statusColor = AppColors.error;
      if (val == 'rejected') {
        displayText = AppStrings.contractValRejected.tr();
      } else {
        displayText = AppStrings.contractValCancelled.tr();
      }
    }

    // Fallback if localization key not found or simple display desired
    if (displayText.startsWith('contract.value.') && statusValue != null) {
      displayText = statusValue;
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: AppColors.textPrimary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: statusColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(6.r),
            border: Border.all(color: statusColor.withOpacity(0.3)),
          ),
          child: Text(
            displayText,
            style: TextStyle(
              color: statusColor,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}
