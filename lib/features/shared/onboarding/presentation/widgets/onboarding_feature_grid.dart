import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/widgets/feature_card.dart';

class OnboardingFeatureGrid extends StatelessWidget {
  const OnboardingFeatureGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final iconColor = AppColors.gold;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: AppSpacing.md,
      crossAxisSpacing: AppSpacing.md,
      childAspectRatio: 0.92,
      children: [
        FeatureCard(
          icon: _svgIcon('assets/icons/icon_photographers.svg', iconColor),
          title: AppStrings.onboardingFeature1Title.tr(),
          subtitle: AppStrings.onboardingFeature1Subtitle.tr(),
          hasShadow: false,
        ),
        FeatureCard(
          icon: _svgIcon('assets/icons/icon_services.svg', iconColor),
          title: AppStrings.onboardingFeature2Title.tr(),
          subtitle: AppStrings.onboardingFeature2Subtitle.tr(),
        ),
        FeatureCard(
          icon: _svgIcon('assets/icons/icon_growth.svg', iconColor),
          title: AppStrings.onboardingFeature3Title.tr(),
          subtitle: AppStrings.onboardingFeature3Subtitle.tr(),
        ),
        FeatureCard(
          icon: _svgIcon('assets/icons/icon_quality.svg', iconColor),
          title: AppStrings.onboardingFeature4Title.tr(),
          subtitle: AppStrings.onboardingFeature4Subtitle.tr(),
        ),
      ],
    );
  }

  Widget _svgIcon(String path, Color color) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: AlignmentDirectional.topStart,
        end: AlignmentDirectional.bottomEnd,
        colors: [
          AppColors.gold.withValues(alpha: 0.22),
          AppColors.gold.withValues(alpha: 0.08),
        ],
      ),
      borderRadius: BorderRadius.circular(16.r),
      border: Border.all(
        color: AppColors.gold.withValues(alpha: 0.18),
        width: 1,
      ),
      boxShadow: [
        BoxShadow(
          color: AppColors.gold.withValues(alpha: 0.12),
          blurRadius: 10.r,
          offset: Offset(0, 4.h),
          spreadRadius: -2.r,
        ),
      ],
    ),
    width: 56.w,
    height: 56.w,
    alignment: Alignment.center,
    child: SvgPicture.asset(
      path,
      width: 28.w,
      height: 28.w,
      colorFilter: ColorFilter.mode(color, BlendMode.srcIn),
    ),
  );
}
