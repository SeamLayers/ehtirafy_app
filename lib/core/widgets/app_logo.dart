import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        ),
      ),
    );
  }
}

