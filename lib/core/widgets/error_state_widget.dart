import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';

class ErrorStateWidget extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;
  final String retryText;

  const ErrorStateWidget({
    super.key,
    required this.message,
    required this.onRetry,
    this.retryText = 'Retry',
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: AppColors.error),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF2B2B2B),
                fontSize: 16.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 24.h),
            OutlinedButton(
              onPressed: onRetry,
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.gold, width: 1.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
                backgroundColor: Colors.transparent,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.refresh, size: 16.sp, color: AppColors.gold),
                  SizedBox(width: 8.w),
                  Text(
                    retryText,
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 14.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
