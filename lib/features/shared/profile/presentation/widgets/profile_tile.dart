import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theme/app_colors.dart';

class ProfileTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDestructive;
  final Widget? trailing;
  final Color? textColor;
  final Color? iconColor;

  const ProfileTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.trailing,
    this.textColor,
    this.iconColor,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final Color accentColor =
        iconColor ?? (isDestructive ? AppColors.error : AppColors.gold);
    final Color labelColor =
        textColor ?? (isDestructive ? AppColors.error : AppColors.textPrimary);
    final Color borderColor = isDestructive
        ? AppColors.error.withValues(alpha: 0.35)
        : AppColors.grey200;
    final BorderRadius radius = BorderRadius.circular(16.r);

    return Material(
      color: Colors.white,
      borderRadius: radius,
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        splashColor: accentColor.withValues(alpha: 0.08),
        highlightColor: accentColor.withValues(alpha: 0.04),
        child: Ink(
          width: double.infinity,
          height: 60.h,
          padding: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: ShapeDecoration(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: isDestructive ? 1.5 : 1,
                color: borderColor,
              ),
              borderRadius: radius,
            ),
            shadows: [
              BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 12.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      padding: EdgeInsets.all(9.w),
                      decoration: BoxDecoration(
                        color: accentColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      child: Icon(
                        icon,
                        color: accentColor,
                        size: 20.sp,
                      ),
                    ),
                    SizedBox(width: 14.w),
                    Expanded(
                      child: Text(
                        title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: labelColor,
                          fontSize: 14.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                          height: 1.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.arrow_forward_ios,
                color: isDestructive
                    ? AppColors.error.withValues(alpha: 0.6)
                    : AppColors.grey400,
                size: 14.sp,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
