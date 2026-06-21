import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';
import '../../domain/entities/freelancer_order_entity.dart';

class FreelancerOrderCard extends StatelessWidget {
  final FreelancerOrderEntity order;
  final VoidCallback? onAccept;
  final VoidCallback? onReject;
  final VoidCallback? onViewDetails;
  final VoidCallback? onChat;

  const FreelancerOrderCard({
    super.key,
    required this.order,
    this.onAccept,
    this.onReject,
    this.onViewDetails,
    this.onChat,
  });

  @override
  Widget build(BuildContext context) {
    final bool hasPendingActions =
        order.status == FreelancerOrderStatus.pending &&
        (onAccept != null || onReject != null);
    final bool hasActiveActions =
        order.status == FreelancerOrderStatus.inProgress &&
        (onViewDetails != null || onChat != null);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
          BoxShadow(
            color: AppColors.shadowLight.withValues(alpha: 0.04),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildClientImage(),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.serviceTitle,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w700,
                        height: 1.3,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 13.sp,
                          color: AppColors.textSecondary,
                        ),
                        SizedBox(width: 4.w),
                        Flexible(
                          child: Text(
                            'العميل: ${order.clientName}',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: AppColors.textSecondary,
                                  fontSize: 12.sp,
                                ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              _buildStatusBadge(context),
            ],
          ),
          SizedBox(height: 12.h),
          // Order details row
          Row(
            children: [
              Flexible(
                child: _buildDetailItem(
                  context,
                  Icons.location_on_outlined,
                  order.location,
                ),
              ),
              SizedBox(width: 12.w),
              Flexible(
                child: _buildDetailItem(
                  context,
                  Icons.calendar_today_outlined,
                  _formatDate(order.eventDate),
                ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildPrice(context), _buildTimeAgo(context)],
          ),
          // Divider before action buttons
          if (hasPendingActions || hasActiveActions) ...[
            SizedBox(height: 12.h),
            const Divider(height: 1, thickness: 1, color: AppColors.grey200),
          ],
          // Action buttons for pending orders
          if (hasPendingActions) _buildPendingActions(context),
          // Action buttons for in-progress orders
          if (hasActiveActions) _buildActiveActions(context),
        ],
      ),
    );
  }

  Widget _buildClientImage() {
    return Container(
      width: 52.w,
      height: 52.w,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight.withValues(alpha: 0.04),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12.r),
        child: AppCachedNetworkImage(
          imageUrl: order.clientImage,
          fit: BoxFit.cover,
          memCacheWidth: 192,
          memCacheHeight: 192,
          errorWidget: Icon(
            Icons.person,
            color: AppColors.grey400,
            size: 24.sp,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color color;
    IconData icon;
    String text;

    switch (order.status) {
      case FreelancerOrderStatus.pending:
        color = AppColors.info;
        icon = Icons.fiber_new_outlined;
        text = 'جديد';
        break;
      case FreelancerOrderStatus.inProgress:
        color = AppColors.success;
        icon = Icons.autorenew;
        text = 'جاري العمل';
        break;
      case FreelancerOrderStatus.completed:
        color = AppColors.success;
        icon = Icons.check_circle_outline;
        text = 'مكتمل';
        break;
      case FreelancerOrderStatus.cancelled:
        color = AppColors.error;
        icon = Icons.cancel_outlined;
        text = 'ملغي';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: color.withValues(alpha: 0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: color),
          SizedBox(width: 4.w),
          Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: color,
              fontSize: 10.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14.sp, color: AppColors.gold),
        SizedBox(width: 4.w),
        Flexible(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 12.sp,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildPrice(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: AppColors.gold.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            '${order.price.toInt()}',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: AppColors.primary,
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            'ريال',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.gold,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeAgo(BuildContext context) {
    final difference = DateTime.now().difference(order.createdAt);
    String timeAgo;
    if (difference.inDays > 0) {
      timeAgo = 'منذ ${difference.inDays} أيام';
    } else if (difference.inHours > 0) {
      timeAgo = 'منذ ${difference.inHours} ساعات';
    } else {
      timeAgo = 'منذ ${difference.inMinutes} دقيقة';
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.access_time_rounded,
          size: 12.sp,
          color: AppColors.textSecondary,
        ),
        SizedBox(width: 4.w),
        Text(
          timeAgo,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 11.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildPendingActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: onReject,
                icon: Icon(Icons.close_rounded, size: 16.sp),
                label: Text(
                  'رفض',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.error,
                  side: BorderSide(
                    color: AppColors.error.withValues(alpha: 0.50),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onAccept,
                icon: Icon(Icons.check_rounded, size: 16.sp),
                label: Text(
                  'قبول',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: AppColors.gold.withValues(alpha: 0.30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildActiveActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: ElevatedButton.icon(
                onPressed: onViewDetails,
                icon: Icon(Icons.visibility_outlined, size: 16.sp),
                label: Text(
                  'عرض التفاصيل',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shadowColor: AppColors.gold.withValues(alpha: 0.30),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
