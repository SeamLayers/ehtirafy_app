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

    return Container(
      padding: EdgeInsets.symmetric(vertical: 20.h),
      child: Column(
        children: [
          Container(
            width: 80.w,
            height: 80.w,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: const Alignment(0.5, 0),
                end: const Alignment(0.5, 1),
                colors: [
                  AppColors.gold,
                  AppColors.gold.withValues(alpha: 0.8),
                ],
              ),
              borderRadius: BorderRadius.circular(16.r),
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
            child: SvgPicture.asset(
              iconAsset,
              width: 40.w,
              height: 40.w,
              colorFilter: const ColorFilter.mode(Color(0xFFFFFFFF), BlendMode.srcIn),
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
