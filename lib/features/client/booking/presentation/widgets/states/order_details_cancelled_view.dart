import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/contract_header.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/contract_status_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsCancelledView extends StatelessWidget {
  final ContractDetailsEntity contract;

  const OrderDetailsCancelledView({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContractHeader(contract: contract),
          SizedBox(height: 16.h),
          ContractThreeStatusCard(contract: contract),
          SizedBox(height: 16.h),
          _buildCancelledMessage(),
        ],
      ),
    );
  }

  Widget _buildCancelledMessage() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.error.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.error),
      ),
      child: Column(
        children: [
          Icon(Icons.cancel_outlined, color: AppColors.error, size: 48.sp),
          SizedBox(height: 12.h),
          Text(
            contract.status == ContractStatus.rejected
                ? AppStrings.contractValRejected.tr()
                : AppStrings.contractValCancelled.tr(),
            style: TextStyle(
              color: AppColors.error,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            contract.status == ContractStatus.rejected
                ? 'تم رفض هذا العقد من قبل المصور'
                : 'تم إلغاء هذا العقد',
            style: TextStyle(color: AppColors.grey500, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
