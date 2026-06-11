import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'guest_mode.dart';

/// Gates account-based actions behind authentication.
///
/// Usage:
/// ```dart
/// onPressed: () {
///   if (!AuthGuard.ensureAuth(context)) return; // guest -> login sheet
///   // ...account-based action...
/// }
/// ```
class AuthGuard {
  AuthGuard._();

  /// Returns `true` if the user is authenticated and may proceed.
  ///
  /// If the user is a guest, shows the login-required bottom sheet and
  /// returns `false` so the caller can abort the action.
  static bool ensureAuth(BuildContext context) {
    if (GuestMode.isLoggedIn) return true;
    showLoginRequiredSheet(context);
    return false;
  }

  /// Shows a modern bottom sheet prompting the guest to log in.
  static void showLoginRequiredSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (sheetContext) => _LoginRequiredSheet(
        onLogin: () {
          Navigator.of(sheetContext).pop();
          context.go('/auth/login');
        },
        onCancel: () => Navigator.of(sheetContext).pop(),
      ),
    );
  }
}

class _LoginRequiredSheet extends StatelessWidget {
  final VoidCallback onLogin;
  final VoidCallback onCancel;

  const _LoginRequiredSheet({required this.onLogin, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28.r)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Grab handle
          Container(
            width: 44.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
          SizedBox(height: 24.h),
          // Lock icon in a gold circle
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(Icons.lock_outline_rounded,
                color: AppColors.gold, size: 36.sp),
          ),
          SizedBox(height: 20.h),
          Text(
            'guest.loginRequiredTitle'.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 10.h),
          Text(
            'guest.loginRequiredMessage'.tr(),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: AppColors.grey600,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 28.h),
          // Login button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onLogin,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                padding: EdgeInsets.symmetric(vertical: 15.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 0,
              ),
              child: Text(
                'guest.login'.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
          SizedBox(height: 10.h),
          // Cancel button
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: onCancel,
              child: Text(
                'guest.cancel'.tr(),
                style: TextStyle(
                  color: AppColors.grey600,
                  fontSize: 15.sp,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
