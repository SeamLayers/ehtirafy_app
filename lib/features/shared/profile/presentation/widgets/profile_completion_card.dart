import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import '../../domain/entities/user_profile_entity.dart';

/// "إكتمال الملف الشخصي" card shown at the top of the profile when the user
/// has not yet added a phone number. Encourages completing the profile to
/// verify the account and build trust with clients.
///
/// Mirrors the visual language of [ProfileHeader]: a white rounded container
/// with a gold-tinted shadow and a grey200 border.
class ProfileCompletionCard extends StatelessWidget {
  final UserProfileEntity user;
  final VoidCallback onTap;

  const ProfileCompletionCard({
    super.key,
    required this.user,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final percent = user.completionPercent;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: AppColors.grey200, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
                spreadRadius: -4,
              ),
              const BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    _CompletionRing(percent: percent),
                    SizedBox(width: AppSpacing.md),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const _IncompleteBadge(),
                          SizedBox(height: AppSpacing.sm),
                          Text(
                            AppStrings.profileCompletionTitle.tr(),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 16.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                              height: 1.40,
                            ),
                          ),
                          SizedBox(height: AppSpacing.xs),
                          Text(
                            AppStrings.profileCompletionPrompt.tr(),
                            maxLines: 3,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w400,
                              height: 1.50,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: AppSpacing.md),
                _CompletionCta(onTap: onTap),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Circular percent ring: a grey background ring with a gold foreground arc and
/// the percentage centered inside. Built from two stacked
/// [CircularProgressIndicator]s — no extra package required.
class _CompletionRing extends StatelessWidget {
  final int percent;

  const _CompletionRing({required this.percent});

  @override
  Widget build(BuildContext context) {
    final size = 60.w;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background ring (full circle, grey).
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: 1,
              strokeWidth: 5.w,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.grey200),
            ),
          ),
          // Foreground arc (gold) up to the current percentage.
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: (percent / 100).clamp(0.0, 1.0),
              strokeWidth: 5.w,
              backgroundColor: Colors.transparent,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          ),
          Text(
            '$percent%',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Small amber "غير مكتمل / Incomplete" pill.
class _IncompleteBadge extends StatelessWidget {
  const _IncompleteBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: AppColors.warning.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(
          color: AppColors.warning.withValues(alpha: 0.30),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error_outline_rounded,
            color: AppColors.warning,
            size: 14.sp,
          ),
          SizedBox(width: 4.w),
          Text(
            AppStrings.profileCompletionBadge.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.warning,
              fontSize: 11.sp,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

/// Gold CTA row that opens the edit-profile screen.
class _CompletionCta extends StatelessWidget {
  final VoidCallback onTap;

  const _CompletionCta({required this.onTap});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.textLight,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.r),
          ),
          elevation: 0,
        ),
        icon: Icon(Icons.add_rounded, size: 18.sp, color: AppColors.textLight),
        label: Text(
          AppStrings.profileCompletionCta.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: AppColors.textLight,
            fontSize: 14.sp,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
