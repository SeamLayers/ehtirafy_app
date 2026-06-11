import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/backend_contract_status_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ApprovedStatusCard extends StatelessWidget {
  static const Color _approvedColor = Color(0xFF28A745);

  final ContractDetailsEntity contract;

  const ApprovedStatusCard({super.key, required this.contract});

  String _fontFamily(BuildContext context) {
    return localizedContractStatusFontFamily(context);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic =
        context.locale.languageCode.toLowerCase().startsWith('ar');
    final localeCode = isArabic ? 'ar' : 'en';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: ShapeDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            _approvedColor.withValues(alpha: 0.08),
            _approvedColor.withValues(alpha: 0.02),
          ],
        ),
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            color: _approvedColor.withValues(alpha: 0.35),
          ),
          borderRadius: BorderRadius.circular(18.r),
        ),
        shadows: [
          BoxShadow(
            color: _approvedColor.withValues(alpha: 0.08),
            blurRadius: 16.r,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Status Text + Badge
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  isArabic ? 'الحالة الحالية' : 'Current Status',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: _fontFamily(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
                decoration: ShapeDecoration(
                  color: _approvedColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  shadows: [
                    BoxShadow(
                      color: _approvedColor.withValues(alpha: 0.30),
                      blurRadius: 8.r,
                      offset: Offset(0, 3.h),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.verified_rounded,
                      color: Colors.white,
                      size: 14.r,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      'Approved',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: _fontFamily(context),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          // Row 2: Service Name + Photographer
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contract.serviceTitle,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        fontFamily: _fontFamily(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Row(
                      children: [
                        Icon(
                          Icons.camera_alt_outlined,
                          color: AppColors.textSecondary,
                          size: 14.r,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            '${AppStrings.bookingPhotographerLabel.tr()}: ${contract.photographerName}',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w400,
                              fontFamily: _fontFamily(context),
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
              SizedBox(width: AppSpacing.sm),
              Container(
                width: 56.w,
                height: 56.w,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    side: BorderSide(
                      width: 1.5,
                      color: AppColors.gold.withValues(alpha: 0.35),
                    ),
                    borderRadius: BorderRadius.circular(16.r),
                  ),
                  shadows: [
                    BoxShadow(
                      color: AppColors.shadowLight,
                      blurRadius: 8.r,
                      offset: Offset(0, 2.h),
                    ),
                  ],
                ),
                child:
                    (contract.photographerImage.isNotEmpty &&
                        contract.photographerImage.startsWith('http'))
                    ? AppCachedNetworkImage(
                        imageUrl: contract.photographerImage,
                        fit: BoxFit.cover,
                        memCacheWidth: 256,
                        memCacheHeight: 256,
                      )
                    : Container(
                        color: AppColors.grey200,
                        child: Icon(
                          Icons.person_outline,
                          color: AppColors.textSecondary,
                          size: 28.r,
                        ),
                      ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          // Inner Card: Details
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: AppColors.grey200),
                borderRadius: BorderRadius.circular(14.r),
              ),
              shadows: [
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 10.r,
                  offset: Offset(0, 4.h),
                ),
              ],
            ),
            child: Column(
              children: [
                _buildDetailRow(
                  context,
                  Icons.event_outlined,
                  AppStrings.contractDateLabel.tr(),
                  DateFormat(
                    'dd MMMM yyyy - HH:mm a',
                    localeCode,
                  ).format(contract.date),
                ),
                SizedBox(height: AppSpacing.sm),
                _buildDetailRow(
                  context,
                  Icons.location_on_outlined,
                  AppStrings.contractLocationLabel.tr(),
                  contract.location,
                ),
                SizedBox(height: AppSpacing.sm),
                Divider(color: AppColors.grey200, height: 1.h),
                SizedBox(height: AppSpacing.sm),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.payments_outlined,
                            color: AppColors.gold,
                            size: 16.r,
                          ),
                          SizedBox(width: 6.w),
                          Flexible(
                            child: Text(
                              AppStrings.contractBudgetLabel.tr(),
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
                                fontFamily: _fontFamily(context),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          NumberFormat('#,###').format(contract.budget),
                          style: TextStyle(
                            color: AppColors.gold,
                            fontSize: 20.sp,
                            fontWeight: FontWeight.w800,
                            fontFamily: _fontFamily(context),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          AppStrings.bookingCurrency.tr(),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w500,
                            fontFamily: _fontFamily(context),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: AppSpacing.md),
          // Pay Button
          SizedBox(
            width: double.infinity,
            height: 52.h,
            child: ElevatedButton(
              onPressed: () {
                context.push('/payment/bank-details/${contract.id}?advId=${contract.advertisementId}');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: Colors.white,
                shadowColor: AppColors.gold.withValues(alpha: 0.4),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline_rounded,
                    color: Colors.white,
                    size: 18.r,
                  ),
                  SizedBox(width: 8.w),
                  Text(
                    AppStrings.contractPayNowAction.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 15.sp,
                      fontWeight: FontWeight.w700,
                      fontFamily: _fontFamily(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          // Security Note
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 13.h),
            decoration: ShapeDecoration(
              color: AppColors.info.withValues(alpha: 0.10),
              shape: RoundedRectangleBorder(
                side: BorderSide(
                  width: 1,
                  color: AppColors.info.withValues(alpha: 0.25),
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.shield_outlined,
                  color: AppColors.info,
                  size: 18.r,
                ),
                SizedBox(width: 8.w),
                Expanded(
                  child: Text(
                    AppStrings.contractPaymentSecureNote.tr(),
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w400,
                      fontFamily: _fontFamily(context),
                      height: 1.63,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: AppColors.textSecondary,
                size: 16.r,
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  label,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: _fontFamily(context),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
              fontFamily: _fontFamily(context),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
