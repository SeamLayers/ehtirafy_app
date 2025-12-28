import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ContractHeader extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ContractHeader({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Row(
        children: [
          Container(
            width: 48.w,
            height: 48.w,
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(
              Icons.description_outlined,
              color: AppColors.primary,
              size: 24.sp,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  contract.serviceTitle,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4.h),
                _buildStatusBadge(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge() {
    String text;
    Color color;

    switch (contract.status) {
      case ContractStatus.inProgress:
        color = AppColors.success;
        text = AppStrings.contractStatusInProgress.tr();
        break;
      case ContractStatus.awaitingPayment:
        color = AppColors.warning;
        text = AppStrings.contractApprovedBadge.tr();
        break;
      case ContractStatus.underReview:
        color = const Color(0xFF17A2B8);
        text = AppStrings.contractStatusUnderReviewBadge.tr();
        break;
      case ContractStatus.archived:
      case ContractStatus.cancelled:
      case ContractStatus.rejected:
        color = AppColors.error;
        text = AppStrings.contractStatusCancelledArchived.tr();
        break;
      case ContractStatus.completed:
        color = AppColors.primary;
        text = AppStrings.myRequestsStatusCompleted.tr();
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
