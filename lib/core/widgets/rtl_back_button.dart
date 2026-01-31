import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'app_colors.dart';

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
    final isRtl = textDirection == TextDirection.rtl;
    
    return IconButton(
      icon: Container(
        padding: showBorder ? EdgeInsets.all(4.w) : null,
        decoration: showBorder
            ? BoxDecoration(
                border: Border.all(
                  color: color ?? AppColors.textPrimary,
                  width: 1.5,
                ),
                shape: BoxShape.circle,
              )
            : null,
        child: Icon(
          isRtl ? Icons.arrow_forward : Icons.arrow_back,
          color: color ?? AppColors.textPrimary,
          size: size ?? 24.sp,
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
    final isRtl = Directionality.of(context) == TextDirection.rtl;
    return IconButton(
      icon: Icon(
        isRtl ? Icons.arrow_forward : Icons.arrow_back,
        color: AppColors.textPrimary,
      ),
      onPressed: onPressed ?? () => context.pop(),
    );
  }
}
