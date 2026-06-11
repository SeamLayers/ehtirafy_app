import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

/// Secondary/Outline button widget
class SecondaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const SecondaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDisabled = isLoading;

    final Color accent = theme.colorScheme.primary;
    final BorderRadius radius = BorderRadius.circular(14.r);

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          // Subtle gold-tinted surface so the outline feels premium, not empty.
          color: isDisabled
              ? accent.withValues(alpha: 0.04)
              : accent.withValues(alpha: 0.06),
          border: Border.all(
            color: isDisabled
                ? accent.withValues(alpha: 0.35)
                : accent.withValues(alpha: 0.85),
            width: 1.5,
          ),
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: accent.withValues(alpha: 0.14),
                    blurRadius: 14.r,
                    offset: Offset(0, 5.h),
                    spreadRadius: -3.r,
                  ),
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 4.r,
                    offset: Offset(0, 1.h),
                  ),
                ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: radius,
            splashColor: accent.withValues(alpha: 0.12),
            highlightColor: accent.withValues(alpha: 0.06),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4.w,
                        valueColor: AlwaysStoppedAnimation<Color>(accent),
                      ),
                    )
                  : Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                      child: Text(
                        text,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: accent,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
