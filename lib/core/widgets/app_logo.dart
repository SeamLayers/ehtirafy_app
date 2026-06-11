import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

/// Reusable AppLogo widget with constrained size
class AppLogo extends StatelessWidget {
  /// Width of the logo (responsive using screenutil)
  final double width;

  /// Optional fixed height for compact placements like AppBars
  final double? height;

  /// Optional BoxFit for the image
  final BoxFit fit;

  const AppLogo({
    super.key,
    this.width = 145,
    this.height,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      height: height?.h,
      child: AspectRatio(
        aspectRatio: height != null ? width / height! : 1,
        child: Image.asset(
          'assets/images/new_logo.png',
          fit: fit,
          // Premium fade-in once the asset is decoded for a smoother appearance.
          frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
            if (wasSynchronouslyLoaded) return child;
            return AnimatedOpacity(
              opacity: frame == null ? 0 : 1,
              duration: const Duration(milliseconds: 350),
              curve: Curves.easeOut,
              child: child,
            );
          },
          // Graceful gold-accented fallback if the asset ever fails to load.
          errorBuilder: (context, error, stackTrace) {
            return Center(
              child: Icon(
                Icons.camera_alt_rounded,
                size: (height != null ? height! * 0.6 : width * 0.42).r,
                color: AppColors.gold,
              ),
            );
          },
        ),
      ),
    );
  }
}

