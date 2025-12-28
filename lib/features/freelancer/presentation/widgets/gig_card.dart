import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
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
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0x1A000000),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: const Color(0xFFF2F2F2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover image with status badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(16.r),
                  ),
                  child: Image.network(
                    gig.coverImage,
                    width: double.infinity,
                    height: 120.h,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => Container(
                      width: double.infinity,
                      height: 120.h,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            AppColors.primary.withValues(alpha: 0.1),
                            AppColors.gold.withValues(alpha: 0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(16.r),
                        ),
                      ),
                      child: Icon(
                        Icons.camera_alt,
                        color: AppColors.primary,
                        size: 40.sp,
                      ),
                    ),
                  ),
                ),
                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(16.r),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                ),
                // Status badge
                Positioned(
                  top: 10.h,
                  right: 10.w,
                  child: _buildStatusBadge(context),
                ),
              ],
            ),
            // Content
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and actions row
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          gig.title,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(
                                color: const Color(0xFF2B2B2B),
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      _buildActions(context),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  // Category and description
                  if (gig.categoryName.isNotEmpty) ...[
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 8.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(6.r),
                      ),
                      child: Text(
                        gig.categoryName,
                        style: TextStyle(
                          color: AppColors.primary,
                          fontSize: 11.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 8.h),
                  ],
                  // Description
                  if (gig.description.isNotEmpty)
                    Text(
                      gig.description,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF888888),
                        fontSize: 12.sp,
                        height: 1.4,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  SizedBox(height: 12.h),
                  // Days availability badges
                  if (gig.availability.isNotEmpty) ...[
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 4.h,
                      children: gig.availability
                          .take(3)
                          .map(
                            (day) => Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(6.r),
                              ),
                              child: Text(
                                _translateDay(day),
                                style: TextStyle(
                                  color: const Color(0xFF666666),
                                  fontSize: 10.sp,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                    SizedBox(height: 12.h),
                  ],
                  // Price row
                  Row(
                    children: [
                      Icon(
                        Icons.monetization_on_outlined,
                        size: 18.sp,
                        color: AppColors.gold,
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        '${gig.price.toInt()}',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppColors.gold,
                          fontSize: 18.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        'ريال',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: const Color(0xFF888888),
                          fontSize: 12.sp,
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
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color backgroundColor;
    String text;

    switch (gig.status) {
      case GigStatus.active:
        backgroundColor = const Color(0xFF28A745);
        text = 'نشط';
        break;
      case GigStatus.pending:
        backgroundColor = const Color(0xFF17A2B8);
        text = 'قيد المراجعة';
        break;
      case GigStatus.inactive:
        backgroundColor = const Color(0xFF6C757D);
        text = 'غير نشط';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
        boxShadow: [
          BoxShadow(
            color: backgroundColor.withValues(alpha: 0.4),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontSize: 11.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (onEdit != null)
          IconButton(
            onPressed: onEdit,
            icon: Icon(Icons.edit_outlined, size: 20.sp),
            color: AppColors.primary,
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 36.w, minHeight: 36.h),
          ),
        if (onDelete != null)
          IconButton(
            onPressed: onDelete,
            icon: Icon(Icons.delete_outline, size: 20.sp),
            color: const Color(0xFFDC3545),
            padding: EdgeInsets.zero,
            constraints: BoxConstraints(minWidth: 36.w, minHeight: 36.h),
          ),
      ],
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
