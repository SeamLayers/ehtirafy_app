import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../constants/app_spacing.dart';

/// Reusable FeatureCard widget for onboarding grid
class FeatureCard extends StatelessWidget {
  /// Icon widget (e.g., Icon or SvgPicture)
  final Widget icon;

  /// Card title text (Arabic or any language)
  final String title;

  /// Optional card subtitle or description
  final String? subtitle;

  /// Whether the card should have shadow/elevation
  final bool hasShadow;

  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    this.subtitle,
    this.hasShadow = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final textTheme = Theme.of(context).textTheme;

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2B2B2B) : Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: isDarkMode
              ? AppColors.grey800
              : AppColors.gold.withValues(alpha: 0.12),
          width: 1,
        ),
        boxShadow: hasShadow
            ? [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.10),
                  blurRadius: 18.r,
                  offset: Offset(0, 6.h),
                  spreadRadius: -4.r,
                ),
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 6.r,
                  offset: Offset(0, 2.h),
                ),
              ]
            : null,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Icon
          SizedBox(
            width: 56.w,
            height: 56.w,
            child: icon,
          ),
          SizedBox(height: AppSpacing.sm + 4.h),
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: isDarkMode ? AppColors.textLight : AppColors.textPrimary,
              height: 1.2,
            ),
          ),
          // Subtitle (optional)
          if (subtitle != null) ...[
            SizedBox(height: AppSpacing.xs + 2.h),
            Flexible(
              child: Text(
                subtitle!,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodySmall?.copyWith(
                  color: isDarkMode ? AppColors.grey400 : AppColors.textSecondary,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
