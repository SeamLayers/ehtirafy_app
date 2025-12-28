import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_colors.dart';

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? subMessage;
  final IconData icon;
  final VoidCallback? onRetry;
  final String? retryText;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.subMessage,
    this.icon = Icons.info_outline,
    this.onRetry,
    this.retryText,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
              ),
              child: Icon(icon, size: 40.sp, color: Colors.grey),
            ),
            SizedBox(height: 16.h),
            Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                color: const Color(0xFF2B2B2B),
                fontSize: 16.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w400,
              ),
            ),
            if (subMessage != null) ...[
              SizedBox(height: 8.h),
              Text(
                subMessage!,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: const Color(0xFF888888),
                  fontSize: 14.sp,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
            if (onRetry != null) ...[
              SizedBox(height: 24.h),
              GestureDetector(
                onTap: onRetry,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Text(
                    retryText ?? 'Retry',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
