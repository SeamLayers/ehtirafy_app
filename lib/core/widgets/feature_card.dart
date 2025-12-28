import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

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

    return Container(
      decoration: BoxDecoration(
        color: isDarkMode ? const Color(0xFF2B2B2B) : Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: AppColors.grey300, width: 1),
        boxShadow: hasShadow
            ? const [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 3,
                  offset: Offset(0, 1),
                  spreadRadius: 0,
                ),
              ]
            : null,
      ),
      padding: EdgeInsets.all(16.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Icon
          SizedBox(
            width: 56.w,
            height: 56.w,
            child: icon,
          ),
          SizedBox(height: 12.h),
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          // Subtitle (optional)
          if (subtitle != null) ...[
            SizedBox(height: 8.h),
            Text(
              subtitle!,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: isDarkMode ? AppColors.grey400 : AppColors.grey600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
