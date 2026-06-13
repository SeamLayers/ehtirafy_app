import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isArabic = context.locale.languageCode == 'ar';
    final brandName = isArabic
        ? 'ملم للمناسبات'
        : 'Malam Events';

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Logo card with a soft gold halo and layered shadow for depth.
          Stack(
            alignment: Alignment.center,
            children: [
              Container(
                width: 200.w,
                height: 200.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.gold.withValues(alpha: isDark ? 0.22 : 0.16),
                      AppColors.gold.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
              Container(
                width: 170.w,
                height: 170.w,
                decoration: BoxDecoration(
                  color: isDark ? AppColors.grey900 : Colors.white,
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.45),
                    width: 1.5.w,
                  ),
                  borderRadius: BorderRadius.circular(32.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.18),
                      blurRadius: 28.r,
                      offset: Offset(0, 16.h),
                      spreadRadius: -8.r,
                    ),
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 12.r,
                      offset: Offset(0, 6.h),
                      spreadRadius: -4.r,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/images/new_logo.png',
                  width: 138.w,
                  height: 138.w,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            brandName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: isDark ? AppColors.textLight : AppColors.textPrimary,
              fontWeight: FontWeight.w800,
              height: 1.25,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          // Subtle gold accent divider under the brand name.
          Container(
            width: 48.w,
            height: 3.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gold.withValues(alpha: 0.0),
                  AppColors.gold,
                  AppColors.gold.withValues(alpha: 0.0),
                ],
              ),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          SizedBox(
            width: 0.78.sw,
            child: Text(
              AppStrings.onboardingSubtitle.tr(),
              textAlign: TextAlign.center,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark ? AppColors.grey400 : AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
