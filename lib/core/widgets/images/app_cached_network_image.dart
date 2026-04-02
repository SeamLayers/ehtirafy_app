import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

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
      color: Colors.grey.shade100,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(12),
      child: Image.asset(
        'assets/images/logocanon.png',
        fit: BoxFit.contain,
        opacity: const AlwaysStoppedAnimation(0.5),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // If imageUrl is empty or invalid, show app logo placeholder directly
    if (imageUrl.isEmpty || !imageUrl.startsWith('http')) {
      final placeholder = errorWidget != null
          ? Container(
              width: width,
              height: height,
              color: Colors.grey.shade100,
              alignment: Alignment.center,
              child: errorWidget,
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
        color: Colors.grey.shade200,
        alignment: Alignment.center,
        child: const SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
      errorWidget: (context, url, error) =>
          errorWidget != null
              ? Container(
                  color: Colors.grey.shade100,
                  alignment: Alignment.center,
                  child: errorWidget,
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