import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/session/guest_mode.dart';
import 'package:ehtirafy_app/core/widgets/primary_button.dart';
import 'package:ehtirafy_app/core/widgets/secondary_button.dart';

class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        PrimaryButton(
          text: AppStrings.onboardingSignup.tr(),
          onPressed: () => context.go('/auth/signup'),
        ),
        SizedBox(height: AppSpacing.sm + 4.h),
        SecondaryButton(
          text: AppStrings.onboardingLogin.tr(),
          onPressed: () => context.go('/auth/login'),
        ),
        SizedBox(height: AppSpacing.md),
        // Continue as guest — lets users browse without an account
        // (App Store guideline 5.1.1).
        _GuestButton(
          onPressed: () async {
            await GuestMode.enter();
            if (context.mounted) context.go('/home');
          },
        ),
        SizedBox(height: AppSpacing.md),
        Text(
          AppStrings.onboardingDisclaimer.tr(),
          textAlign: TextAlign.center,
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}

/// Subtle gold-tinted pill that invites guest browsing without competing
/// with the primary/secondary CTAs above it.
class _GuestButton extends StatelessWidget {
  const _GuestButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(12.r);

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onPressed,
        borderRadius: radius,
        splashColor: AppColors.gold.withValues(alpha: 0.10),
        highlightColor: AppColors.gold.withValues(alpha: 0.05),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.06),
            borderRadius: radius,
            border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.20),
              width: 1,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 2.h,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.explore_outlined,
                  color: AppColors.gold,
                  size: 18.sp,
                ),
                SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    AppStrings.onboardingContinueAsGuest.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: 'Cairo',
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
