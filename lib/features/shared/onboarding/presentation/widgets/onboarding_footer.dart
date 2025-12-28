import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/widgets/primary_button.dart';
import 'package:ehtirafy_app/core/widgets/secondary_button.dart';

class OnboardingFooter extends StatelessWidget {
  const OnboardingFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        PrimaryButton(
          text: AppStrings.onboardingSignup.tr(),
          onPressed: () => context.go('/auth/signup'),
        ),
        SizedBox(height: 12.h),
        SecondaryButton(
          text: AppStrings.onboardingLogin.tr(),
          onPressed: () => context.go('/auth/login'),
        ),
        SizedBox(height: 12.h),
        Text(
          AppStrings.onboardingDisclaimer.tr(),
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
