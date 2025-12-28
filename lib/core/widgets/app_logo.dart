import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Reusable AppLogo widget with constrained size
class AppLogo extends StatelessWidget {
  /// Width of the logo (responsive using screenutil)
  final double width;

  /// Optional BoxFit for the image
  final BoxFit fit;

  const AppLogo({
    super.key,
    this.width = 145,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width.w,
      child: AspectRatio(
        aspectRatio: 1,
        child: Image.asset(
          'assets/images/logo.png',
          fit: fit,
        ),
      ),
    );
  }
}

