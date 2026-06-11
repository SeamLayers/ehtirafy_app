import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';

class OutlinedRefreshButton extends StatelessWidget {
  final VoidCallback onPressed;

  const OutlinedRefreshButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(20.r);

    return SizedBox(
      height: 32.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [
              AppColors.gold.withValues(alpha: 0.10),
              AppColors.gold.withValues(alpha: 0.03),
            ],
          ),
          border: Border.all(
            color: AppColors.gold.withValues(alpha: 0.55),
            width: 1.0,
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.12),
              blurRadius: 8.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: radius,
          child: InkWell(
            onTap: onPressed,
            borderRadius: radius,
            splashColor: AppColors.gold.withValues(alpha: 0.18),
            highlightColor: AppColors.gold.withValues(alpha: 0.08),
            child: Padding(
              padding: EdgeInsetsDirectional.symmetric(horizontal: 12.w),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.refresh_rounded,
                    size: 15.sp,
                    color: AppColors.gold,
                  ),
                  SizedBox(width: 6.w),
                  Text(
                    'refresh'.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.0,
                      letterSpacing: 0.2,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
