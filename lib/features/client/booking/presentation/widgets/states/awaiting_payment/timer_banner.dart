import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/backend_contract_status_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TimerBanner extends StatelessWidget {
  const TimerBanner({super.key});

  // Warning accent used across the banner.
  static const Color _accent = AppColors.error;

  String _fontFamily(BuildContext context) {
    return localizedContractStatusFontFamily(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            _accent.withValues(alpha: 0.08),
            _accent.withValues(alpha: 0.03),
          ],
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: _accent.withValues(alpha: 0.35),
          width: 1.4,
        ),
        boxShadow: [
          BoxShadow(
            color: _accent.withValues(alpha: 0.10),
            blurRadius: 18.r,
            offset: Offset(0, 8.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(8.r),
                decoration: BoxDecoration(
                  color: _accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  Icons.timer_outlined,
                  color: _accent,
                  size: 20.r,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(top: 2.h),
                  child: Text(
                    AppStrings.contractPaymentWarningTitle.tr(),
                    style: TextStyle(
                      color: _accent,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: _fontFamily(context),
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _timerValue(context, '44'),
              SizedBox(width: AppSpacing.xs),
              Text(
                AppStrings.minute.tr(),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: _fontFamily(context),
                  height: 1.5,
                ),
              ),
              SizedBox(width: AppSpacing.md),
              _timerValue(context, '23'),
              SizedBox(width: AppSpacing.xs),
              Text(
                AppStrings.hour.tr(),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: _fontFamily(context),
                  height: 1.5,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            AppStrings.contractPaymentWarningBody.tr(),
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 13.sp,
              fontWeight: FontWeight.w400,
              fontFamily: _fontFamily(context),
              height: 1.63,
            ),
          ),
        ],
      ),
    );
  }

  Widget _timerValue(BuildContext context, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.textLight,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: _accent.withValues(alpha: 0.25),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 6.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Text(
        value,
        style: TextStyle(
          color: _accent,
          fontSize: 26.sp,
          fontWeight: FontWeight.w700,
          fontFamily: _fontFamily(context),
          height: 1.2,
        ),
      ),
    );
  }
}
