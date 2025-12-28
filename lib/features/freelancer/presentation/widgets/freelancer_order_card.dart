import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
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
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0D000000),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFF2F2F2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
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
                        color: const Color(0xFF2B2B2B),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      'العميل: ${order.clientName}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF888888),
                        fontSize: 12.sp,
                      ),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(context),
            ],
          ),
          SizedBox(height: 12.h),
          // Order details row
          Row(
            children: [
              _buildDetailItem(
                context,
                Icons.location_on_outlined,
                order.location,
              ),
              SizedBox(width: 16.w),
              _buildDetailItem(
                context,
                Icons.calendar_today_outlined,
                _formatDate(order.eventDate),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [_buildPrice(context), _buildTimeAgo(context)],
          ),
          // Action buttons for pending orders
          if (order.status == FreelancerOrderStatus.pending &&
              (onAccept != null || onReject != null))
            _buildPendingActions(context),
          // Action buttons for in-progress orders
          if (order.status == FreelancerOrderStatus.inProgress &&
              (onViewDetails != null || onChat != null))
            _buildActiveActions(context),
        ],
      ),
    );
  }

  Widget _buildClientImage() {
    return Container(
      width: 48.w,
      height: 48.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(color: const Color(0xFFEFEFEF)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8.r),
        child: Image.network(
          order.clientImage,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Container(
            color: const Color(0xFFF5F5F5),
            child: Icon(Icons.person, color: Colors.grey, size: 24.sp),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color backgroundColor;
    String text;

    switch (order.status) {
      case FreelancerOrderStatus.pending:
        backgroundColor = const Color(0xFF17A2B8);
        text = 'جديد';
        break;
      case FreelancerOrderStatus.inProgress:
        backgroundColor = const Color(0xFF28A745);
        text = 'جاري العمل';
        break;
      case FreelancerOrderStatus.completed:
        backgroundColor = const Color(0xFF28A745);
        text = 'مكتمل';
        break;
      case FreelancerOrderStatus.cancelled:
        backgroundColor = const Color(0xFFDC3545);
        text = 'ملغي';
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontSize: 10.sp,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildDetailItem(BuildContext context, IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14.sp, color: const Color(0xFF888888)),
        SizedBox(width: 4.w),
        Text(
          text,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: const Color(0xFF888888),
            fontSize: 12.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildPrice(BuildContext context) {
    return Row(
      children: [
        Text(
          '${order.price.toInt()}',
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
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

    return Text(
      timeAgo,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        color: const Color(0xFF888888),
        fontSize: 11.sp,
      ),
    );
  }

  Widget _buildPendingActions(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 12.h),
        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: onReject,
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFFDC3545),
                  side: const BorderSide(color: Color(0xFFDC3545)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: Text(
                  'رفض',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: onAccept,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: Text(
                  'قبول',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
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
              child: OutlinedButton.icon(
                onPressed: onChat,
                icon: Icon(Icons.chat_outlined, size: 16.sp),
                label: Text('محادثة', style: TextStyle(fontSize: 14.sp)),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.primary,
                  side: BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            Expanded(
              child: ElevatedButton(
                onPressed: onViewDetails,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                ),
                child: Text(
                  'عرض التفاصيل',
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
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
