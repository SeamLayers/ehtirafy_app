import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';

class ServiceCard extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final String description;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.id,
    required this.title,
    required this.price,
    required this.description,
    this.imageUrl,
    this.onTap,
  });

  final String? imageUrl;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(color: AppColors.grey200, width: 1),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.06),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
              BoxShadow(
                color: AppColors.shadowLight.withValues(alpha: 0.04),
                blurRadius: 8,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (hasImage) ...[
                ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: AppColors.grey100, width: 1),
                    ),
                    child: AppCachedNetworkImage(
                      imageUrl: imageUrl!,
                      width: 84.w,
                      height: 84.w,
                      fit: BoxFit.cover,
                      memCacheWidth: 320,
                      memCacheHeight: 320,
                      borderRadius: BorderRadius.circular(14.r),
                      errorWidget: const Icon(
                        Icons.broken_image_outlined,
                        color: AppColors.grey400,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: AppSpacing.md),
              ],
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            title,
                            style: theme.textTheme.titleMedium?.copyWith(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        _PriceBadge(price: price),
                      ],
                    ),
                    SizedBox(height: AppSpacing.sm),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 13.5.sp,
                        color: AppColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    if (onTap != null) ...[
                      SizedBox(height: 12.h),
                      Container(
                        padding: EdgeInsetsDirectional.symmetric(
                          horizontal: 14.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: AlignmentDirectional.centerStart,
                            end: AlignmentDirectional.centerEnd,
                            colors: [
                              AppColors.gold.withValues(alpha: 0.16),
                              AppColors.gold.withValues(alpha: 0.08),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.25),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.visibility_outlined,
                              color: AppColors.gold,
                              size: 14.sp,
                            ),
                            SizedBox(width: 6.w),
                            Text(
                              'عرض الإعلان',
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                color: AppColors.gold,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PriceBadge extends StatelessWidget {
  final double price;

  const _PriceBadge({required this.price});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsetsDirectional.symmetric(
        horizontal: 10.w,
        vertical: 5.h,
      ),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Text(
        '$price ${AppStrings.bookingCurrency.tr()}',
        style: TextStyle(
          fontFamily: 'Cairo',
          fontSize: 14.sp,
          fontWeight: FontWeight.w700,
          color: AppColors.gold,
        ),
      ),
    );
  }
}
