import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimerBanner extends StatelessWidget {
  const TimerBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w, bottom: 16.h),
      decoration: ShapeDecoration(
        color: const Color(0x0CDC3545), // Light red background
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2, color: Color(0xFFDC3545)),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.contractPaymentWarningTitle.tr(),
            style: TextStyle(
              color: const Color(0xFFDC3545),
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              fontFamily: 'Cairo',
              height: 1.5,
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _timerValue('44'),
              SizedBox(width: 8.w),
              Text(
                AppStrings.minute.tr(),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Cairo',
                  height: 1.5,
                ),
              ),
              SizedBox(width: 16.w),
              _timerValue('23'),
              SizedBox(width: 8.w),
              Text(
                AppStrings.hour.tr(),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  fontFamily: 'Cairo',
                  height: 1.5,
                ),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Text(
            AppStrings.contractPaymentWarningBody.tr(),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              fontFamily: 'Cairo',
              height: 1.63,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timerValue(String value) {
    return Text(
      value,
      style: TextStyle(
        color: const Color(0xFFDC3545),
        fontSize: 30.sp,
        fontWeight: FontWeight.w700,
        fontFamily: 'Cairo',
        height: 1.2,
      ),
    );
  }
}
