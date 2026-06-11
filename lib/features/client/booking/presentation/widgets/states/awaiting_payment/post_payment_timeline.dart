import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/backend_contract_status_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PostPaymentTimeline extends StatelessWidget {
  const PostPaymentTimeline({super.key});

  String _fontFamily(BuildContext context) {
    return localizedContractStatusFontFamily(context);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(width: 1, color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.06),
            blurRadius: 18.r,
            offset: Offset(0, 6.h),
          ),
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10.r,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          SizedBox(height: AppSpacing.md),
          _buildTimelineStep(
            context,
            '1',
            AppStrings.contractStep1Confirm.tr(),
            isLast: false,
          ),
          _buildTimelineStep(
            context,
            '2',
            AppStrings.contractStep2Prepare.tr(),
            isLast: false,
          ),
          _buildTimelineStep(
            context,
            '3',
            AppStrings.contractStep3Contact.tr(),
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36.w,
          height: 36.w,
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(
            Icons.event_available_rounded,
            color: AppColors.gold,
            size: 20.sp,
          ),
        ),
        SizedBox(width: AppSpacing.sm + 2.w),
        Expanded(
          child: Text(
            AppStrings.contractWhatHappensAfterPayment.tr(),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              fontFamily: _fontFamily(context),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineStep(
    BuildContext context,
    String number,
    String text, {
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [AppColors.gold, Color(0xFFD9BD78)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.30),
                      blurRadius: 6.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    number,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: _fontFamily(context),
                    ),
                  ),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2.w,
                    margin: EdgeInsets.symmetric(vertical: 4.h),
                    color: AppColors.gold.withValues(alpha: 0.20),
                  ),
                ),
            ],
          ),
          SizedBox(width: AppSpacing.sm + 4.w),
          Expanded(
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                top: 4.h,
                bottom: isLast ? 0 : AppSpacing.md,
              ),
              child: Text(
                text,
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                  height: 1.5,
                  fontWeight: FontWeight.w500,
                  fontFamily: _fontFamily(context),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
