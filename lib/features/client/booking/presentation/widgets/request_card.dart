import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/cards/request_card_base.dart';
import 'package:ehtirafy_app/features/client/requests/domain/entities/request_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/widgets/user_avatar.dart';

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
      footer: _buildActionButton(context),
    );
  }

  Widget _buildPhotographerImage() {
    return UserAvatar(name: request.photographerName, imageUrl: request.photographerImage, size: 56);
  }

  Widget _buildServiceName(BuildContext context) {
    return Text(
      request.serviceName,
      maxLines: 1,
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

    // Logic for Badge Color and Text
    if (request.status == RequestStatus.underReview) {
      statusColor = AppColors.grey500; // Grey for Waiting Approval
      text = AppStrings.myRequestsStatusUnderReview.tr(); // "Waiting Approval"
    } else if (request.status == RequestStatus.active) {
      if (request.isPaymentRequired) {
        statusColor = AppColors.success; // Green for Approved
        text = AppStrings.myRequestsStatusApproved.tr(); // "Approved"
      } else {
        statusColor = AppColors.info; // Blue for In Progress
        text = AppStrings.contractStatusInProgress.tr(); // "In Progress"
      }
    } else if (request.status == RequestStatus.completed) {
      statusColor = AppColors.success;
      text = AppStrings.myRequestsStatusCompleted.tr();
    } else {
      // Cancelled
      statusColor = AppColors.error;
      text = AppStrings.myRequestsStatusCancelled.tr();
    }

    return Container(
      padding: EdgeInsetsDirectional.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: ShapeDecoration(
        color: statusColor.withValues(alpha: 0.12),
        shape: RoundedRectangleBorder(
          side: BorderSide(color: statusColor.withValues(alpha: 0.22)),
          borderRadius: BorderRadius.circular(9.r),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6.r,
            height: 6.r,
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
                height: 1.33,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrice(BuildContext context) {
    return Row(
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
              fontSize: 17.sp,
              fontWeight: FontWeight.w800,
              height: 1.40,
            ),
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          AppStrings.myRequestsCurrency.tr(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
            fontSize: 13.sp,
            fontWeight: FontWeight.w600,
            height: 1.43,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeAgo(BuildContext context) {
    final difference = DateTime.now().difference(request.date);
    String timeAgo;
    if (difference.inDays > 0) {
      timeAgo = 'منذ ${difference.inDays} أيام';
    } else if (difference.inHours > 0) {
      timeAgo = 'منذ ${difference.inHours} ساعات';
    } else {
      timeAgo = 'منذ ${difference.inMinutes} دقيقة';
    }

    return Align(
      alignment: AlignmentDirectional.centerEnd,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.access_time_rounded,
            size: 14.r,
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

  Widget _buildActionButton(BuildContext context) {
    String buttonText = AppStrings.bookingDetailsTitle
        .tr(); // Default "View Details"
    Color buttonColor = Colors.white;
    Color textColor = AppColors.primary;
    bool isOutlined = true;

    if (request.status == RequestStatus.underReview) {
      // Pending Approval -> View Details
      buttonText = AppStrings.bookingDetailsTitle.tr();
      buttonColor = Colors.white;
      textColor = AppColors.primary;
      isOutlined = true;
    } else if (request.status == RequestStatus.active) {
      if (request.isPaymentRequired) {
        // Awaiting Payment -> Pay Now
        buttonText = AppStrings.myRequestsPayNow.tr();
        buttonColor = AppColors.primary; // Gold
        textColor = Colors.white;
        isOutlined = false;
      } else {
        // In Progress -> View Status
        buttonText = AppStrings.bookingDetailsTitle
            .tr(); // Or specific "View Status" string if available
        buttonColor = Colors.white;
        textColor = AppColors.primary;
        isOutlined = true;
      }
    } else if (request.status == RequestStatus.completed) {
      // Completed -> Rate Service
      buttonText = AppStrings.myRequestsRateService.tr();
      buttonColor = Colors.white;
      textColor = AppColors.primary;
      isOutlined = true;
    } else {
      // Cancelled
      return const SizedBox.shrink();
    }

    return GestureDetector(
      onTap: () {
        if (request.status == RequestStatus.active &&
            request.isPaymentRequired) {
          // Call payment callback if provided, otherwise navigate to details
          if (onPayPressed != null) {
            onPayPressed!();
          } else {
            context.push('/contract/${request.id}');
          }
        } else if (request.status == RequestStatus.completed) {
          // Navigate to rate screen
          context.push(
            '/rate-service',
            extra: {
              'freelancerId': request.photographerId,
              'freelancerName': request.photographerName,
              'serviceName': request.serviceName,
              'advertisementId': request.advertisementId,
            },
          );
        } else {
          // Navigate to details
          context.push('/contract/${request.id}');
        }
      },
      child: Container(
        width: double.infinity,
        height: 46.h,
        decoration: ShapeDecoration(
          color: buttonColor,
          shape: RoundedRectangleBorder(
            side: isOutlined
                ? BorderSide(
                    width: 1.4,
                    color: AppColors.primary.withValues(alpha: 0.6),
                  )
                : BorderSide.none,
            borderRadius: BorderRadius.circular(12.r),
          ),
          shadows: isOutlined
              ? null
              : [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.28),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: Center(
          child: Text(
            buttonText,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontSize: 14.sp,
              fontWeight: FontWeight.w700,
              height: 1.43,
            ),
          ),
        ),
      ),
    );
  }
}
