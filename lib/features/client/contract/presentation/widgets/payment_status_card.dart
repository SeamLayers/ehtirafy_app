import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PaymentStatusCard extends StatelessWidget {
  final ContractDetailsEntity contract;

  const PaymentStatusCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.contractPaymentStatusLabel.tr(),
            style: TextStyle(color: AppColors.grey500, fontSize: 12.sp),
          ),
          SizedBox(height: 12.h),
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.check, color: Colors.white, size: 12.sp),
              ),
              SizedBox(width: 8.w),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppStrings.contractPaymentStatusDeposited.tr(),
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${NumberFormat('#,###').format(contract.budget)} ${AppStrings.bookingCurrency.tr()}',
                      style: TextStyle(
                        color: AppColors.success,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            AppStrings.contractPaymentSecureMessage.tr(),
            style: TextStyle(color: AppColors.grey500, fontSize: 12.sp),
          ),
        ],
      ),
    );
  }
}
