import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/constants/app_strings.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/primary_button.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.xl,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Success badge with layered soft halo.
                Container(
                  width: 140.r,
                  height: 140.r,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.success.withValues(alpha: 0.08),
                  ),
                  child: Center(
                    child: Container(
                      width: 104.r,
                      height: 104.r,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.success.withValues(alpha: 0.14),
                      ),
                      child: Center(
                        child: Container(
                          width: 76.r,
                          height: 76.r,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: AlignmentDirectional.topStart,
                              end: AlignmentDirectional.bottomEnd,
                              colors: [
                                AppColors.success,
                                AppColors.success.withValues(alpha: 0.85),
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: AppColors.success.withValues(alpha: 0.32),
                                blurRadius: 20.r,
                                offset: Offset(0, 8.h),
                                spreadRadius: -2.r,
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.check_rounded,
                            color: AppColors.textLight,
                            size: 44.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: AppSpacing.xl),
                Text(
                  AppStrings.bookingSuccessTitle.tr(),
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.md),
                Text(
                  AppStrings.bookingSuccessMessage.tr(),
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontSize: 15.sp,
                    height: 1.6,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: AppSpacing.xxl),
                PrimaryButton(
                  text: AppStrings.bookingBackToHome.tr(),
                  onPressed: () => context.go('/home'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
