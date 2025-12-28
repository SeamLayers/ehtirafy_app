import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';

class OnboardingBanner extends StatelessWidget {
  const OnboardingBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: const Alignment(0, 0),
          end: const Alignment(1, 1),
          colors: [
            AppColors.gold.withValues(alpha: 0.1),
            AppColors.gold.withValues(alpha: 0.05),
          ],
        ),
        border: Border.all(
          color: AppColors.gold.withValues(alpha: 0.2),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32.w,
            height: 32.w,
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/icons/icon_community.svg',
              width: 24.w,
              height: 24.w,
              colorFilter: const ColorFilter.mode(
                AppColors.gold,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppStrings.onboardingBannerTitle.tr(),
                  style: theme.textTheme.titleMedium,
                ),
                SizedBox(height: 8.h),
                Text(
                  AppStrings.onboardingBannerSubtitle.tr(),
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
