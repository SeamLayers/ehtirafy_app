import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_colors.dart';

class UserAvatar extends StatelessWidget {
  final String name;
  final String? imageUrl;
  final double size;
  final double? fontSize;

  const UserAvatar({
    super.key,
    required this.name,
    this.imageUrl,
    this.size = 50,
    this.fontSize,
  });

  bool get _hasImage =>
      imageUrl != null && imageUrl!.isNotEmpty && imageUrl!.startsWith('http');

  String _getInitials(String name) {
    if (name.isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  Widget _buildInitials() {
    return Center(
      child: Text(
        _getInitials(name),
        textAlign: TextAlign.center,
        maxLines: 1,
        overflow: TextOverflow.clip,
        style: TextStyle(
          color: AppColors.textLight,
          fontSize: fontSize ?? (size * 0.4).sp,
          fontWeight: FontWeight.w700,
          fontFamily: 'Cairo',
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildImageLoader() {
    return Center(
      child: SizedBox(
        width: (size * 0.4).w,
        height: (size * 0.4).w,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
          backgroundColor: AppColors.gold.withValues(alpha: 0.15),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double borderWidth = (size * 0.045).clamp(1.5, 3.0);

    return Container(
      width: size.w,
      height: size.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: _hasImage
            ? null
            : const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.gold,
                  Color(0xFFD4AF37),
                ],
              ),
        color: _hasImage ? AppColors.grey100 : null,
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.28),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
          const BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 4,
            offset: Offset(0, 1),
          ),
        ],
        border: Border.all(
          color: AppColors.textLight,
          width: borderWidth,
        ),
      ),
      child: ClipOval(
        child: _hasImage
            ? CachedNetworkImage(
                imageUrl: imageUrl!,
                fit: BoxFit.cover,
                width: size.w,
                height: size.w,
                placeholder: (context, url) => _buildImageLoader(),
                errorWidget: (context, url, error) => _buildInitials(),
              )
            : _buildInitials(),
      ),
    );
  }
}
