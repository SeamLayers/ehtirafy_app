import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import '../widgets/onboarding_header.dart';
import '../widgets/onboarding_feature_grid.dart';
import '../widgets/onboarding_banner.dart';
import '../widgets/onboarding_footer.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppColors.dark : AppColors.backgroundLight,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: const [
                OnboardingHeader(),
                SizedBox(height: 24),
                OnboardingFeatureGrid(),
                SizedBox(height: 24),
                OnboardingBanner(),
                SizedBox(height: 24),
                OnboardingFooter(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
