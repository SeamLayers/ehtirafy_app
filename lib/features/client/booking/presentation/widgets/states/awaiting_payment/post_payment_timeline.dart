import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostPaymentTimeline extends StatelessWidget {
  const PostPaymentTimeline({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: AppColors.grey300),
          borderRadius: BorderRadius.circular(14.r),
        ),
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
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 12.h),
          _buildTimelineStep(
            context,
            '1',
            AppStrings.contractStep1Confirm.tr(),
          ),
          SizedBox(height: 12.h),
          _buildTimelineStep(
            context,
            '2',
            AppStrings.contractStep2Prepare.tr(),
          ),
          SizedBox(height: 12.h),
          _buildTimelineStep(
            context,
            '3',
            AppStrings.contractStep3Contact.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(BuildContext context, String number, String text) {
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.h,
          decoration: const ShapeDecoration(
            color: AppColors.gold,
            shape: CircleBorder(),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ],
    );
  }
}
