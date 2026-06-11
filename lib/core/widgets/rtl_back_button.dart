import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';

/// RTL-aware back button widget
/// Automatically handles direction based on text direction
class RtlBackButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final Color? color;
  final double? size;
  final bool showBorder;

  const RtlBackButton({
    super.key,
    this.onPressed,
    this.color,
    this.size,
    this.showBorder = false,
  });

  @override
  Widget build(BuildContext context) {
    final textDirection = Directionality.of(context);
    final isRtl = textDirection == ui.TextDirection.rtl;
    
    final Color iconColor = color ?? AppColors.textPrimary;
    final double iconSize = size ?? 24.sp;

    return IconButton(
      splashRadius: 24.r,
      icon: Container(
        padding: EdgeInsets.all(showBorder ? 6.w : 4.w),
        decoration: showBorder
            ? BoxDecoration(
                color: iconColor.withValues(alpha: 0.06),
                border: Border.all(
                  color: iconColor.withValues(alpha: 0.45),
                  width: 1.5,
                ),
                shape: BoxShape.circle,
              )
            : BoxDecoration(
                color: AppColors.gold.withValues(alpha: 0.10),
                shape: BoxShape.circle,
              ),
        child: Icon(
          isRtl
              ? Icons.arrow_forward_ios_rounded
              : Icons.arrow_back_ios_new_rounded,
          color: iconColor,
          size: iconSize * 0.8,
        ),
      ),
      onPressed: onPressed ?? () => context.pop(),
      tooltip: isRtl ? 'رجوع' : 'Back',
    );
  }
}

/// Simple replacement for default back button
class BackButtonRtl extends StatelessWidget {
  final VoidCallback? onPressed;

  const BackButtonRtl({super.key, this.onPressed});

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == ui.TextDirection.rtl;
    return IconButton(
      splashRadius: 24.r,
      icon: Container(
        padding: EdgeInsets.all(4.w),
        decoration: BoxDecoration(
          color: AppColors.gold.withValues(alpha: 0.10),
          shape: BoxShape.circle,
        ),
        child: Icon(
          isRtl
              ? Icons.arrow_forward_ios_rounded
              : Icons.arrow_back_ios_new_rounded,
          color: AppColors.textPrimary,
          size: 18.sp,
        ),
      ),
      onPressed: onPressed ?? () => context.pop(),
    );
  }
}
