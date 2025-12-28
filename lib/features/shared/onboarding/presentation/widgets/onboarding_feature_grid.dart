import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
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
      mainAxisSpacing: 16.h,
      crossAxisSpacing: 16.w,
      childAspectRatio: 0.92,
      children: [
        FeatureCard(
          icon: _svgIcon('assets/icons/icon_services.svg', iconColor),
          title: AppStrings.services.tr(),
          subtitle: AppStrings.onboardingServicesSubtitle.tr(),
          hasShadow: false,
        ),
        FeatureCard(
          icon: _svgIcon('assets/icons/icon_photographers.svg', iconColor),
          title: AppStrings.roleFreelancer.tr(),
          subtitle: AppStrings.onboardingPhotographersSubtitle.tr(),
        ),
        FeatureCard(
          icon: _svgIcon('assets/icons/icon_growth.svg', iconColor),
          title: AppStrings.growth.tr(),
          subtitle: AppStrings.onboardingGrowthSubtitle.tr(),
        ),
        FeatureCard(
          icon: _svgIcon('assets/icons/icon_quality.svg', iconColor),
          title: AppStrings.quality.tr(),
          subtitle: AppStrings.onboardingQualitySubtitle.tr(),
        ),
      ],
    );
  }

  Widget _svgIcon(String path, Color color) => Container(
    decoration: BoxDecoration(
      gradient: LinearGradient(
        begin: const Alignment(0, 0),
        end: const Alignment(1, 1),
        colors: [
          AppColors.gold.withValues(alpha: 0.2),
          AppColors.gold.withValues(alpha: 0.1),
        ],
      ),
      borderRadius: BorderRadius.circular(16.r),
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
