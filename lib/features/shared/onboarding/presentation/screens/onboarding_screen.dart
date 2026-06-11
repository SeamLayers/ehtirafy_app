import 'package:flutter/material.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
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
      body: Container(
        // Subtle premium gold-tinted backdrop that fades into the base
        // surface — adds depth behind the brand logo without being noisy.
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? [
                    AppColors.gold.withValues(alpha: 0.08),
                    AppColors.dark,
                  ]
                : [
                    AppColors.gold.withValues(alpha: 0.06),
                    AppColors.backgroundLight,
                  ],
            stops: const [0.0, 0.45],
          ),
        ),
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    minHeight: constraints.maxHeight,
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.md,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const OnboardingHeader(),
                        SizedBox(height: AppSpacing.lg),
                        const OnboardingFeatureGrid(),
                        SizedBox(height: AppSpacing.lg),
                        const OnboardingBanner(),
                        SizedBox(height: AppSpacing.lg),
                        const OnboardingFooter(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
