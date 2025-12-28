import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsPendingView extends StatelessWidget {
  final ContractDetailsEntity contract;

  const OrderDetailsPendingView({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9F9F9),
      child: SingleChildScrollView(
        padding: EdgeInsets.only(
          top: 24.h,
          left: 20.w,
          right: 20.w,
          bottom: 24.h,
        ),
        child: Column(
          children: [
            _buildStatusCard(context),
            SizedBox(height: 16.h),
            _buildTimeline(context),
            SizedBox(height: 32.h),
            _buildCancelButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 48.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.error.withOpacity(0.5)),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0A000000),
            blurRadius: 4,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Center(
        child: Text(
          AppStrings.cancel.tr(),
          style: TextStyle(
            color: AppColors.error,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            fontFamily: 'Cairo',
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: const Color(0xFFF0FDF4), // Softer Light Green
        shape: RoundedRectangleBorder(
          side: const BorderSide(
            width: 1,
            color: Color(0xFFDCFCE7), // Subtle Green Border
          ),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: [
          BoxShadow(
            color: const Color(0x0A000000),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Status Text + Badge
          Row(
            children: [
              Flexible(
                child: Text(
                  AppStrings.pendingViewStatusText.tr(),
                  style: TextStyle(
                    color: const Color(0xFF888888),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Cairo',
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: ShapeDecoration(
                  color: const Color(0xFF17A2B8), // Cyan/Teal
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  AppStrings.pendingViewBadgeText.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Row 2: Service Name + Photographer
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contract.serviceTitle,
                      style: TextStyle(
                        color: const Color(0xFF2B2B2B),
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Cairo',
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${AppStrings.bookingPhotographerLabel.tr()}: ${contract.photographerName}',
                      style: TextStyle(
                        color: const Color(0xFF888888),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 56.w,
                height: 56.h,
                decoration: ShapeDecoration(
                  image: DecorationImage(
                    image: NetworkImage(contract.photographerImage),
                    fit: BoxFit.cover,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          // Inner Card: Details
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Column(
              children: [
                _buildDetailRow(
                  context,
                  AppStrings.contractDateAndTime.tr(),
                  DateFormat(
                    'dd MMMM yyyy - hh:mm a',
                    'ar',
                  ).format(contract.date),
                ),
                SizedBox(height: 8.h),
                _buildDetailRow(
                  context,
                  AppStrings.contractLocation.tr(),
                  contract.location,
                ),
                SizedBox(height: 8.h),
                // Price Row with Border
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: ShapeDecoration(
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(
                        width: 1,
                        color: Color(0xFFE5E5E5),
                      ),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          AppStrings.contractRequiredAmount.tr(),
                          style: TextStyle(
                            color: const Color(0xFF888888),
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Cairo',
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            NumberFormat('#,###').format(contract.budget),
                            style: TextStyle(
                              color: const Color(0xFFC8A44F), // Gold
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            AppStrings.bookingCurrency.tr(),
                            style: TextStyle(
                              color: const Color(0xFF888888),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: 'Cairo',
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
        ],
      ),
    );
  }

  Widget _buildDetailRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            color: const Color(0xFF888888),
            fontSize: 14.sp,
            fontWeight: FontWeight.w400,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: const Color(0xFF2B2B2B),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              fontFamily: 'Cairo',
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFF3F4F6)),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: [
          BoxShadow(
            color: const Color(0x0A000000),
            blurRadius: 10,
            offset: const Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            AppStrings.pendingViewTimelineTitle.tr(),
            style: TextStyle(
              color: const Color(0xFF2B2B2B),
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 12.h),
          _buildTimelineStep(
            context,
            '1',
            AppStrings.pendingViewTimelineStep1.tr(),
          ),
          SizedBox(height: 12.h),
          _buildTimelineStep(
            context,
            '2',
            AppStrings.pendingViewTimelineStep2.tr(),
          ),
          SizedBox(height: 12.h),
          _buildTimelineStep(
            context,
            '3',
            AppStrings.pendingViewTimelineStep3.tr(),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep(BuildContext context, String number, String text) {
    return Row(
      children: [
        Container(
          width: 24.w,
          height: 24.h,
          decoration: const ShapeDecoration(
            color: Color(0xFFC8A44F), // Gold
            shape: CircleBorder(),
          ),
          child: Center(
            child: Text(
              number,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: const Color(0xFF888888),
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ],
    );
  }
}
