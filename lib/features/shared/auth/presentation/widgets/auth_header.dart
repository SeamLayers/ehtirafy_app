import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';

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

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          Container(
            width: 92.w,
            height: 92.w,
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.45),
                width: 1.4,
              ),
              borderRadius: BorderRadius.circular(18.r),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 6,
                  offset: Offset(0, 4),
                  spreadRadius: -4,
                ),
                BoxShadow(
                  color: Color(0x19000000),
                  blurRadius: 15,
                  offset: Offset(0, 10),
                  spreadRadius: -3,
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
          SizedBox(height: 20.h),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              color: isDark ? AppColors.textLight : AppColors.textPrimary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: 8.h),
          SizedBox(
            width: 0.75.sw,
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: isDark ? AppColors.grey400 : AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
