import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';

class AuthHeader extends StatelessWidget {
  final String iconAsset;
  final String title;
  final String subtitle;

  const AuthHeader({
    super.key,
    required this.iconAsset,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final isSvg = iconAsset.toLowerCase().endsWith('.svg');

    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.lg),
      child: Column(
        children: [
          // Soft gold halo behind the icon badge for a premium glow.
          Container(
            width: 100.w,
            height: 100.w,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  AppColors.gold.withValues(alpha: isDark ? 0.20 : 0.14),
                  AppColors.gold.withValues(alpha: 0.0),
                ],
              ),
            ),
            child: Container(
              width: 88.w,
              height: 88.w,
              decoration: BoxDecoration(
                color: isDark ? AppColors.grey900 : Colors.white,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: isDark
                      ? [AppColors.grey800, AppColors.grey900]
                      : [Colors.white, AppColors.grey50],
                ),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.40),
                  width: 1.4,
                ),
                borderRadius: BorderRadius.circular(20.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.18),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                    spreadRadius: -4,
                  ),
                  const BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 12,
                    offset: Offset(0, 4),
                    spreadRadius: -2,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: isSvg
                  ? SvgPicture.asset(
                      iconAsset,
                      width: 44.w,
                      height: 44.w,
                      colorFilter: const ColorFilter.mode(
                        AppColors.gold,
                        BlendMode.srcIn,
                      ),
                    )
                  : Image.asset(
                      iconAsset,
                      width: 70.w,
                      height: 70.w,
                      fit: BoxFit.contain,
                    ),
            ),
          ),
          SizedBox(height: AppSpacing.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              color: isDark ? AppColors.textLight : AppColors.textPrimary,
              fontWeight: FontWeight.w700,
              height: 1.25,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          // Subtle gold underline accent beneath the title.
          Container(
            width: 36.w,
            height: 3.h,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppColors.gold.withValues(alpha: 0.35),
                  AppColors.gold,
                  AppColors.gold.withValues(alpha: 0.35),
                ],
              ),
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          SizedBox(
            width: 0.78.sw,
            child: Text(
              subtitle,
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
