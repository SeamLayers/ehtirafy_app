import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/cards/request_card_base.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/request_entity.dart';

class RequestCard extends StatelessWidget {
  final RequestEntity request;
  final VoidCallback? onPayPressed;

  const RequestCard({super.key, required this.request, this.onPayPressed});

  @override
  Widget build(BuildContext context) {
    return RequestCardBase(
      onTap: () => context.push('/contract/${request.id}'),
      avatar: _buildPhotographerImage(),
      title: _buildServiceName(context),
      subtitle: _buildPhotographerName(context),
      statusBadge: _buildStatusBadge(context),
      price: _buildPrice(context),
      timeAgo: _buildTimeAgo(context),
      footer: request.isPaymentRequired && request.status == RequestStatus.active
          ? _buildPaymentSection(context)
          : null,
    );
  }

  Widget _buildPhotographerImage() {
    return Container(
      width: 56.w,
      height: 56.h,
      padding: EdgeInsets.all(4.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: AppColors.grey200),
          borderRadius: BorderRadius.circular(12.r),
        ),
        shadows: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.06),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: DecoratedBox(
        decoration: ShapeDecoration(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.r),
          ),
          color: AppColors.grey100,
        ),
        child: AppCachedNetworkImage(
          imageUrl: request.photographerImage,
          fit: BoxFit.cover,
          memCacheWidth: 256,
          memCacheHeight: 256,
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
    );
  }

  Widget _buildServiceName(BuildContext context) {
    return Text(
      request.serviceName,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: AppColors.textPrimary,
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        height: 1.40,
      ),
    );
  }

  Widget _buildPhotographerName(BuildContext context) {
    return Text(
      '${AppStrings.myRequestsPhotographerLabel.tr()}: ${request.photographerName}',
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: AppColors.textSecondary,
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 1.43,
      ),
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color statusColor;
    String text;

    switch (request.status) {
      case RequestStatus.active:
        statusColor = AppColors.success;
        text = request.isPaymentRequired
            ? AppStrings.myRequestsStatusApproved.tr()
            : AppStrings.myRequestsStatusActive.tr();
        break;
      case RequestStatus.underReview:
        statusColor = AppColors.info;
        text = AppStrings.myRequestsStatusUnderReview.tr();
        break;
      case RequestStatus.completed:
        statusColor = AppColors.success;
        text = AppStrings.myRequestsStatusCompleted.tr();
        break;
      case RequestStatus.cancelled:
        statusColor = AppColors.error;
        text = AppStrings.myRequestsStatusCancelled.tr();
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: ShapeDecoration(
        color: statusColor.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: statusColor.withValues(alpha: 0.22),
          ),
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7.r,
            height: 7.r,
            decoration: BoxDecoration(
              color: statusColor,
              shape: BoxShape.circle,
            ),
          ),
          SizedBox(width: 6.w),
          Flexible(
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: statusColor,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
                height: 1.20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrice(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: ShapeDecoration(
        color: AppColors.gold.withValues(alpha: 0.10),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.baseline,
        textBaseline: TextBaseline.alphabetic,
        children: [
          Flexible(
            child: Text(
              NumberFormat('#,###').format(request.price),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.primary,
                fontSize: 16.sp,
                fontWeight: FontWeight.w800,
                height: 1.20,
              ),
            ),
          ),
          SizedBox(width: 4.w),
          Text(
            AppStrings.myRequestsCurrency.tr(),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.primary.withValues(alpha: 0.75),
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              height: 1.20,
            ),
          ),
        ],
      ),
    );
  }

  /// Build a relative elapsed-duration phrase from a real DateTime (e.g.
  /// created_at or approvedDate). Returns the bare duration without the
  /// "منذ" prefix so callers can prepend their own ("منذ" / "تمت الموافقة منذ").
  String _formatElapsed(DateTime dateTime) {
    final difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays} أيام';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ساعات';
    } else {
      return '${difference.inMinutes} دقيقة';
    }
  }

  Widget _buildTimeAgo(BuildContext context) {
    // Relative time computed from the real contract created_at date.
    final timeAgo = 'منذ ${_formatElapsed(request.date)}';

    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 13.r,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: 4.w),
          Flexible(
            child: Text(
              timeAgo,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.textSecondary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                height: 1.33,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (request.approvedDate != null) ...[
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.verified_outlined,
                size: 14.r,
                color: AppColors.success,
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  '${AppStrings.myRequestsApprovedSince.tr()} ${_formatElapsed(request.approvedDate!)}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.33,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
        ],
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(13.w),
          decoration: ShapeDecoration(
            color: AppColors.gold.withValues(alpha: 0.10),
            shape: RoundedRectangleBorder(
              side: BorderSide(
                width: 1,
                color: AppColors.gold.withValues(alpha: 0.22),
              ),
              borderRadius: BorderRadius.circular(12.r),
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 18.r,
                color: AppColors.gold,
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  AppStrings.myRequestsPaymentMessage.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    height: 1.55,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: AppSpacing.md),
        GestureDetector(
          onTap: onPayPressed,
          child: Container(
            width: double.infinity,
            height: 48.h,
            decoration: ShapeDecoration(
              gradient: LinearGradient(
                begin: AlignmentDirectional.centerStart,
                end: AlignmentDirectional.centerEnd,
                colors: [
                  AppColors.gold,
                  AppColors.gold.withValues(alpha: 0.85),
                ],
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              shadows: [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.30),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.payments_outlined,
                    size: 18.r,
                    color: AppColors.textLight,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    AppStrings.myRequestsPayNow.tr(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textLight,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
