import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/backend_contract_status_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsPendingView extends StatelessWidget {
  final ContractDetailsEntity contract;

  const OrderDetailsPendingView({super.key, required this.contract});

  String _fontFamily(BuildContext context) {
    return localizedContractStatusFontFamily(context);
  }

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
        border: Border.all(color: AppColors.error.withValues(alpha: 0.5)),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 4,
            offset: Offset(0, 2),
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
            fontFamily: _fontFamily(context),
          ),
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    final isArabic =
        context.locale.languageCode.toLowerCase().startsWith('ar');
    final localeCode = isArabic ? 'ar' : 'en';

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
        shadows: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
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
                  isArabic ? 'الحالة الحالية' : 'Current Status',
                  style: TextStyle(
                    color: const Color(0xFF888888),
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: _fontFamily(context),
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
                  'Initiate',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: _fontFamily(context),
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
                        fontFamily: _fontFamily(context),
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${AppStrings.bookingPhotographerLabel.tr()}: ${contract.photographerName}',
                      style: TextStyle(
                        color: const Color(0xFF888888),
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: _fontFamily(context),
                      ),
                    ),
                  ],
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: AppCachedNetworkImage(
                  imageUrl: contract.photographerImage,
                  width: 56.w,
                  height: 56.h,
                  fit: BoxFit.cover,
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
                    localeCode,
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
                            fontFamily: _fontFamily(context),
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
                              fontFamily: _fontFamily(context),
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            AppStrings.bookingCurrency.tr(),
                            style: TextStyle(
                              color: const Color(0xFF888888),
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: _fontFamily(context),
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
            fontFamily: _fontFamily(context),
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
              fontFamily: _fontFamily(context),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  Widget _buildTimeline(BuildContext context) {
    final isArabic =
      context.locale.languageCode.toLowerCase().startsWith('ar');

    final steps = [
      isArabic
        ? 'Initiate: تم إنشاء العقد وبانتظار موافقة المصور.'
        : 'Initiate: Contract created and waiting for freelancer approval.',
      isArabic
        ? 'Approved: عند قبول المصور ينتقل العقد للحالة التالية.'
        : 'Approved: Once freelancer accepts, the contract moves forward.',
      isArabic
        ? 'InProgress: تبدأ مرحلة التنفيذ والمتابعة.'
        : 'InProgress: Service execution starts and progress is tracked.',
      isArabic
        ? 'Closed: بعد التأكيد النهائي يتم إغلاق العقد.'
        : 'Closed: After final confirmation, the contract is closed.',
    ];

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFF3F4F6)),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: const [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, 4),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic
                ? 'تسلسل الحالة (Backend Flow)'
                : 'Status Sequence (Backend Flow)',
            style: TextStyle(
              color: const Color(0xFF2B2B2B),
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              fontFamily: _fontFamily(context),
            ),
          ),
          SizedBox(height: 12.h),
          _buildTimelineStep(
            context,
            '1',
            steps[0],
          ),
          SizedBox(height: 12.h),
          _buildTimelineStep(
            context,
            '2',
            steps[1],
          ),
          SizedBox(height: 12.h),
          _buildTimelineStep(
            context,
            '3',
            steps[2],
          ),
          SizedBox(height: 12.h),
          _buildTimelineStep(
            context,
            '4',
            steps[3],
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
                fontFamily: _fontFamily(context),
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
              fontFamily: _fontFamily(context),
            ),
          ),
        ),
      ],
    );
  }
}
