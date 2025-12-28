import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';

class OutlinedRefreshButton extends StatelessWidget {
  final VoidCallback onPressed;

  const OutlinedRefreshButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32.h,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          side: const BorderSide(color: AppColors.gold, width: 1.0),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          backgroundColor: Colors.transparent,
          // Removed minimumSize constraints to allow smaller height
          minimumSize: Size.zero,
          tapTargetSize:
              MaterialTapTargetSize.shrinkWrap, // To reduce default padding
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.refresh_rounded, size: 14.sp, color: AppColors.gold),
            SizedBox(width: 4.w),
            Text(
              // Using a generic refresh string or adding a new one if needed.
              // Assuming AppStrings.refresh exists or we use a hardcoded fallback for now if it doesn't.
              // Since I checked AppStrings before and it's large, I'll check if 'refresh' key exists in tr()
              // or just use a safe fallback.
              'تحديث', // "Refresh" in Arabic roughly, or use tr() key if available.
              // Better to use tr('refresh') and ensure key exists or fallback.
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
                fontFamily: 'Cairo', // Assuming Cairo is the app font
              ),
            ),
          ],
        ),
      ),
    );
  }
}
