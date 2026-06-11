import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
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
      color: AppColors.backgroundLight,
      child: SingleChildScrollView(
        padding: EdgeInsetsDirectional.only(
          top: AppSpacing.lg,
          start: 20.w,
          end: 20.w,
          bottom: AppSpacing.lg,
        ),
        child: Column(
          children: [
            _buildStatusCard(context),
            SizedBox(height: AppSpacing.xl),
            _buildCancelButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCancelButton(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 52.h,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: AppColors.error.withValues(alpha: 0.45)),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.close_rounded,
              color: AppColors.error,
              size: 18.r,
            ),
            SizedBox(width: AppSpacing.sm),
            Text(
              AppStrings.cancel.tr(),
              style: TextStyle(
                color: AppColors.error,
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                fontFamily: _fontFamily(context),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusCard(BuildContext context) {
    final isArabic =
        context.locale.languageCode.toLowerCase().startsWith('ar');
    final localeCode = isArabic ? 'ar' : 'en';
    final statusUi = backendContractStatusUi('Initiate');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16,
            offset: Offset(0, 6),
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
                    color: AppColors.textSecondary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    fontFamily: _fontFamily(context),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: 10.w,
                  vertical: 5.h,
                ),
                decoration: BoxDecoration(
                  color: statusUi.softColor,
                  borderRadius: BorderRadius.circular(10.r),
                  border: Border.all(
                    color: statusUi.color.withValues(alpha: 0.25),
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      statusUi.icon,
                      size: 14.r,
                      color: statusUi.color,
                    ),
                    SizedBox(width: 5.w),
                    Text(
                      'Initiate',
                      style: TextStyle(
                        color: statusUi.color,
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
            crossAxisAlignment: CrossAxisAlignment.start,
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
                        height: 1.3,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: AppSpacing.xs),
                    Text(
                      '${AppStrings.bookingPhotographerLabel.tr()}: ${contract.photographerName}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: _fontFamily(context),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.4),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14.r),
                  child: AppCachedNetworkImage(
                    imageUrl: contract.photographerImage,
                    width: 56.w,
                    height: 56.h,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          // Inner Card: Details
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.circular(14.r),
              border: Border.all(color: AppColors.grey200),
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
                  icon: Icons.event_outlined,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.h),
                  child: const Divider(
                    height: 1,
                    thickness: 1,
                    color: AppColors.grey200,
                  ),
                ),
                _buildDetailRow(
                  context,
                  AppStrings.contractLocation.tr(),
                  contract.location,
                  icon: Icons.location_on_outlined,
                ),
                SizedBox(height: AppSpacing.md),
                // Price Row with gold-tinted highlight
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.25),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            Icon(
                              Icons.payments_outlined,
                              size: 18.r,
                              color: AppColors.gold,
                            ),
                            SizedBox(width: AppSpacing.sm),
                            Flexible(
                              child: Text(
                                AppStrings.contractRequiredAmount.tr(),
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
                              fontWeight: FontWeight.w700,
                              fontFamily: _fontFamily(context),
                            ),
                          ),
                          SizedBox(width: AppSpacing.xs),
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
    String label,
    String value, {
    IconData? icon,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (icon != null) ...[
          Icon(
            icon,
            size: 18.r,
            color: AppColors.textSecondary,
          ),
          SizedBox(width: AppSpacing.sm),
        ],
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
            fontFamily: _fontFamily(context),
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
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

}
