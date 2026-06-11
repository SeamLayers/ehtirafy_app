import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';
import '../../domain/entities/gig_entity.dart';

class GigCard extends StatelessWidget {
  final GigEntity gig;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final VoidCallback? onTap;

  const GigCard({
    super.key,
    required this.gig,
    this.onEdit,
    this.onDelete,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(20.r),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.06),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
              const BoxShadow(
                color: AppColors.shadowLight,
                blurRadius: 12,
                offset: Offset(0, 4),
              ),
            ],
            border: Border.all(color: AppColors.grey200),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cover image with status badge
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.r),
                    ),
                    child: AppCachedNetworkImage(
                      imageUrl: gig.coverImage,
                      width: double.infinity,
                      height: 130.h,
                      fit: BoxFit.cover,
                      memCacheWidth: 640,
                      memCacheHeight: 360,
                      errorWidget: Icon(
                        Icons.camera_alt_rounded,
                        color: AppColors.primary,
                        size: 40.sp,
                      ),
                    ),
                  ),
                  // Gradient overlay
                  Positioned.fill(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(20.r),
                        ),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.dark.withValues(alpha: 0.35),
                          ],
                        ),
                      ),
                    ),
                  ),
                  // Status badge
                  PositionedDirectional(
                    top: 12.h,
                    end: 12.w,
                    child: _buildStatusBadge(context),
                  ),
                ],
              ),
              // Content
              Padding(
                padding: EdgeInsets.all(AppSpacing.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and actions row
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: EdgeInsetsDirectional.only(top: 4.h),
                            child: Text(
                              gig.title,
                              style: Theme.of(context).textTheme.bodyLarge
                                  ?.copyWith(
                                    color: AppColors.textPrimary,
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w700,
                                    height: 1.3,
                                  ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        _buildActions(context),
                      ],
                    ),
                    SizedBox(height: AppSpacing.sm),
                    // Category chip
                    if (gig.categoryName.isNotEmpty) ...[
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 5.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.primary.withValues(alpha: 0.2),
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.local_offer_rounded,
                              size: 12.sp,
                              color: AppColors.primary,
                            ),
                            SizedBox(width: 5.w),
                            Flexible(
                              child: Text(
                                gig.categoryName,
                                style: TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 11.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                    ],
                    // Description
                    if (gig.description.isNotEmpty)
                      Text(
                        gig.description,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12.sp,
                          height: 1.5,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    SizedBox(height: 12.h),
                    // Days availability badges
                    if (gig.availability.isNotEmpty) ...[
                      Wrap(
                        spacing: 6.w,
                        runSpacing: 6.h,
                        children: gig.availability
                            .take(3)
                            .map(
                              (day) => Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 10.w,
                                  vertical: 5.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.grey100,
                                  borderRadius: BorderRadius.circular(8.r),
                                  border: Border.all(color: AppColors.grey200),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.calendar_today_rounded,
                                      size: 10.sp,
                                      color: AppColors.grey600,
                                    ),
                                    SizedBox(width: 4.w),
                                    Text(
                                      _translateDay(day),
                                      style: TextStyle(
                                        color: AppColors.grey700,
                                        fontSize: 10.sp,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                      SizedBox(height: 12.h),
                    ],
                    const Divider(
                      height: 1,
                      thickness: 1,
                      color: AppColors.grey100,
                    ),
                    SizedBox(height: 12.h),
                    // Price row
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(7.r),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppColors.gold.withValues(alpha: 0.18),
                                AppColors.gold.withValues(alpha: 0.08),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(10.r),
                          ),
                          child: Icon(
                            Icons.payments_rounded,
                            size: 16.sp,
                            color: AppColors.gold,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Text(
                          '${gig.price.toInt()}',
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: AppColors.gold,
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          'ريال',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: AppColors.textSecondary,
                                fontSize: 12.sp,
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color backgroundColor;
    String text;

    switch (gig.status) {
      case GigStatus.active:
        backgroundColor = AppColors.success;
        text = 'نشط';
        break;
      case GigStatus.pending:
        backgroundColor = AppColors.info;
        text = 'قيد المراجعة';
        break;
      case GigStatus.inactive:
        backgroundColor = AppColors.grey500;
        text = 'غير نشط';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.white.withValues(alpha: 0.6)),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.4),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.w,
            height: 6.w,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 5.w),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white,
              fontSize: 11.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          _buildActionButton(
            icon: Icons.edit_outlined,
            color: AppColors.primary,
            onPressed: onEdit,
          ),
        if (onEdit != null && onDelete != null) SizedBox(width: 6.w),
        if (onDelete != null)
          _buildActionButton(
            icon: Icons.delete_outline_rounded,
            color: AppColors.error,
            onPressed: onDelete,
          ),
      ],
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required Color color,
    required VoidCallback? onPressed,
  }) {
    return Material(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(10.r),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10.r),
        child: Padding(
          padding: EdgeInsets.all(8.r),
          child: Icon(icon, size: 18.sp, color: color),
        ),
      ),
    );
  }

  String _translateDay(String day) {
    switch (day.toLowerCase()) {
      case 'saturday':
        return 'السبت';
      case 'sunday':
        return 'الأحد';
      case 'monday':
        return 'الاثنين';
      case 'tuesday':
        return 'الثلاثاء';
      case 'wednesday':
        return 'الأربعاء';
      case 'thursday':
        return 'الخميس';
      case 'friday':
        return 'الجمعة';
      default:
        return day;
    }
  }
}
