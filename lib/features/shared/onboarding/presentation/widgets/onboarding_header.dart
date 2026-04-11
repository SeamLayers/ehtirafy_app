import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';

class OnboardingHeader extends StatelessWidget {
  const OnboardingHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isArabic = context.locale.languageCode == 'ar';
    final brandName = isArabic ? 'البطل' : 'Al-Batal';
    final brandTagline = isArabic
        ? 'تصوير مناسباتك، بلمسة إبداع.'
        : 'Your Event Photography, Perfected.';

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          Container(
            width: 170.w,
            height: 170.w,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.5),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(28.r),
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
            child: Image.asset(
              'assets/images/logocanon.png',
              width: 138.w,
              height: 138.w,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(height: 18.h),
          Text(
            brandName,
            textAlign: TextAlign.center,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: isDark ? AppColors.textLight : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
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
