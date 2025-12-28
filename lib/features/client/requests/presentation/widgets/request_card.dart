import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
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
    return InkWell(
      onTap: () {
        context.push('/contract/${request.id}');
      },
      child: Container(
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
              spreadRadius: 0,
            ),
          ],
          border: Border.all(color: const Color(0xFFF2F2F2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildPhotographerImage(),
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildServiceName(context),
                      SizedBox(height: 8.h),
                      _buildPhotographerName(context),
                      SizedBox(height: 8.h),
                      _buildStatusAndPrice(context),
                      SizedBox(height: 8.h),
                      _buildTimeAgo(context),
                    ],
                  ),
                ),
              ],
            ),
            if (request.isPaymentRequired &&
                request.status == RequestStatus.active)
              _buildPaymentSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildPhotographerImage() {
    return Container(
      width: 56.w,
      height: 56.h,
      padding: EdgeInsets.all(8.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xAAEFEFEF)),
          borderRadius: BorderRadius.circular(8.r),
        ),
      ),
      child: Container(
        decoration: ShapeDecoration(
          image: DecorationImage(
            image: NetworkImage(request.photographerImage),
            fit: BoxFit.cover,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.r),
          ),
        ),
      ),
    );
  }

  Widget _buildServiceName(BuildContext context) {
    return Text(
      request.serviceName,
      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
        color: const Color(0xFF2B2B2B),
        fontSize: 16.sp,
        fontWeight: FontWeight.w400,
        height: 1.50,
      ),
    );
  }

  Widget _buildPhotographerName(BuildContext context) {
    return Text(
      '${AppStrings.myRequestsPhotographerLabel.tr()}: ${request.photographerName}',
      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
        color: const Color(0xFF888888),
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        height: 1.43,
      ),
    );
  }

  Widget _buildStatusAndPrice(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [_buildStatusBadge(context), _buildPrice(context)],
    );
  }

  Widget _buildStatusBadge(BuildContext context) {
    Color backgroundColor;
    String text;

    switch (request.status) {
      case RequestStatus.active:
        backgroundColor = const Color(0xFF28A745);
        text = request.isPaymentRequired
            ? AppStrings.myRequestsStatusApproved.tr()
            : AppStrings.myRequestsStatusActive.tr();
        break;
      case RequestStatus.underReview:
        backgroundColor = const Color(0xFF17A2B8);
        text = AppStrings.myRequestsStatusUnderReview.tr();
        break;
      case RequestStatus.completed:
        backgroundColor = const Color(0xFF28A745);
        text = AppStrings.myRequestsStatusCompleted.tr();
        break;
      case RequestStatus.cancelled:
        backgroundColor = const Color(0xFFDC3545);
        text = AppStrings.myRequestsStatusCancelled.tr();
        break;
    }

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.r)),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
          height: 1.33,
        ),
      ),
    );
  }

  Widget _buildPrice(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.baseline,
      textBaseline: TextBaseline.alphabetic,
      children: [
        Text(
          NumberFormat('#,###').format(request.price),
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            color: AppColors.primary,
            fontSize: 16.sp,
            fontWeight: FontWeight.w400,
            height: 1.50,
          ),
        ),
        SizedBox(width: 4.w),
        Text(
          AppStrings.myRequestsCurrency.tr(),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: const Color(0xFF888888),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            height: 1.43,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeAgo(BuildContext context) {
    // Simple time ago logic for demo purposes
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
      child: Text(
        timeAgo,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
          color: const Color(0xFF888888),
          fontSize: 12.sp,
          fontWeight: FontWeight.w400,
          height: 1.33,
        ),
      ),
    );
  }

  Widget _buildPaymentSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 8.h),
        if (request.approvedDate != null)
          Text(
            '${AppStrings.myRequestsApprovedSince.tr()} 30 دقيقة', // Mocked time
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFF888888),
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
              height: 1.33,
            ),
          ),
        SizedBox(height: 8.h),
        Container(
          width: double.infinity,
          padding: EdgeInsets.all(13.w),
          decoration: ShapeDecoration(
            color: const Color(0x19C8A44F),
            shape: RoundedRectangleBorder(
              side: const BorderSide(width: 1, color: Color(0x33C8A34E)),
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  AppStrings.myRequestsPaymentMessage.tr(),
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: const Color(0xFF2B2B2B),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    height: 1.63,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 8.h),
        GestureDetector(
          onTap: onPayPressed,
          child: Container(
            width: double.infinity,
            height: 44.h,
            decoration: ShapeDecoration(
              color: AppColors.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Center(
              child: Text(
                AppStrings.myRequestsPayNow.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  height: 1.43,
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 16.h),
      ],
    );
  }
}
