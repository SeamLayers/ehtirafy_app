import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_colors.dart';

class AppCachedNetworkImage extends StatelessWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final int? memCacheWidth;
  final int? memCacheHeight;
  final BorderRadius? borderRadius;
  final Widget? errorWidget;

  const AppCachedNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.memCacheWidth,
    this.memCacheHeight,
    this.borderRadius,
    this.errorWidget,
  });

  /// App logo placeholder used when no API image is available
  static Widget _buildLogoPlaceholder({double? width, double? height}) {
    return Container(
      width: width,
      height: height,
      alignment: Alignment.center,
      padding: EdgeInsets.all(12.r),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.grey100,
            AppColors.grey200,
          ],
        ),
      ),
      child: Image.asset(
        'assets/images/new_logo.png',
        fit: BoxFit.contain,
        opacity: const AlwaysStoppedAnimation(0.5),
      ),
    );
  }

  /// Wraps a custom [errorWidget] in a subtle, consistent surface.
  static Widget _buildErrorSurface({
    required Widget child,
    double? width,
    double? height,
  }) {
    return Container(
      width: width,
      height: height,
      color: AppColors.grey100,
      alignment: Alignment.center,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    // If imageUrl is empty or invalid, show app logo placeholder directly
    if (imageUrl.isEmpty || !imageUrl.startsWith('http')) {
      final placeholder = errorWidget != null
          ? _buildErrorSurface(
              width: width,
              height: height,
              child: errorWidget!,
            )
          : _buildLogoPlaceholder(width: width, height: height);

      if (borderRadius != null) {
        return ClipRRect(borderRadius: borderRadius!, child: placeholder);
      }
      return placeholder;
    }

    final image = CachedNetworkImage(
      imageUrl: imageUrl,
      width: width,
      height: height,
      fit: fit,
      memCacheWidth: memCacheWidth,
      memCacheHeight: memCacheHeight,
      placeholder: (context, url) => Container(
        width: width,
        height: height,
        color: AppColors.grey100,
        alignment: Alignment.center,
        child: SizedBox(
          width: 22.r,
          height: 22.r,
          child: const CircularProgressIndicator(
            strokeWidth: 2.2,
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
          ),
        ),
      ),
      errorWidget: (context, url, error) => errorWidget != null
          ? _buildErrorSurface(
              width: width,
              height: height,
              child: errorWidget!,
            )
          : _buildLogoPlaceholder(width: width, height: height),
    );

    if (borderRadius == null) {
      return image;
    }

    return ClipRRect(
      borderRadius: borderRadius!,
      child: image,
    );
  }
}
