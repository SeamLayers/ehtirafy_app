import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;

  const PrimaryButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isDisabled = isLoading;

    final BorderRadius radius = BorderRadius.circular(14.r);

    return SizedBox(
      width: double.infinity,
      height: 56.h,
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: radius,
          gradient: isDisabled
              ? null
              : LinearGradient(
                  begin: AlignmentDirectional.topStart,
                  end: AlignmentDirectional.bottomEnd,
                  colors: [
                    AppColors.gold.withValues(alpha: 0.95),
                    AppColors.gold,
                    const Color(0xFFB8923F),
                  ],
                  stops: const [0.0, 0.55, 1.0],
                ),
          color: isDisabled ? AppColors.gold.withValues(alpha: 0.55) : null,
          boxShadow: isDisabled
              ? null
              : [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.32),
                    blurRadius: 16.r,
                    offset: Offset(0, 6.h),
                    spreadRadius: -2.r,
                  ),
                  BoxShadow(
                    color: AppColors.shadowLight,
                    blurRadius: 6.r,
                    offset: Offset(0, 2.h),
                  ),
                ],
        ),
        child: Material(
          type: MaterialType.transparency,
          child: InkWell(
            onTap: isLoading ? null : onPressed,
            borderRadius: radius,
            splashColor: AppColors.textLight.withValues(alpha: 0.12),
            highlightColor: AppColors.textLight.withValues(alpha: 0.06),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 22.r,
                      height: 22.r,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.4.r,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.textLight.withValues(alpha: 0.9),
                        ),
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
                          color: AppColors.textLight,
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
