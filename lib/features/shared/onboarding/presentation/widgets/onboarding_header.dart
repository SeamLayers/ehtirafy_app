import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          Container(
            width: 96.w,
            height: 96.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(0.5, 0),
                end: const Alignment(0.5, 1),
                colors: [AppColors.gold, AppColors.gold.withValues(alpha: 0.8)],
              ),
              borderRadius: BorderRadius.circular(24.r),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 10,
                  offset: Offset(0, 8),
                  spreadRadius: -6,
                ),
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 25,
                  offset: Offset(0, 20),
                  spreadRadius: -5,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: SvgPicture.asset(
              'assets/icons/camera_icon.svg',
              width: 64.w,
              height: 64.w,
              colorFilter: const ColorFilter.mode(
                AppColors.textLight,
                BlendMode.srcIn,
              ),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            AppStrings.onboardingWelcome.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: isDark ? AppColors.textLight : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: 0.75.sw,
            child: Text(
              AppStrings.onboardingSubtitle.tr(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark ? AppColors.grey400 : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
