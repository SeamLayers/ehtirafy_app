import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/manager/contract_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ApprovedStatusCard extends StatelessWidget {
  final ContractDetailsEntity contract;

  const ApprovedStatusCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: const Color(0x0C28A745), // Light green
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFF28A745)),
          borderRadius: BorderRadius.circular(14.r),
        ),
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
                  AppStrings.contractPhotographerApprovedTitle.tr(),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Cairo',
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 2.h),
                decoration: ShapeDecoration(
                  color: const Color(0xFF28A745),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                ),
                child: Text(
                  AppStrings.contractApprovedBadge.tr(),
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
          SizedBox(height: 12.h),
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
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      '${AppStrings.bookingPhotographerLabel.tr()}: ${contract.photographerName}',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w400,
                        fontFamily: 'Cairo',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Container(
                width: 56.w,
                height: 56.h,
                clipBehavior: Clip.antiAlias,
                decoration: ShapeDecoration(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
                child:
                    (contract.photographerImage.isNotEmpty &&
                        contract.photographerImage.startsWith('http'))
                    ? Image.network(
                        contract.photographerImage,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => Container(
                          color: const Color(0xFFECECEC),
                          child: Icon(
                            Icons.person_outline,
                            color: AppColors.textSecondary,
                            size: 28.r,
                          ),
                        ),
                      )
                    : Container(
                        color: const Color(0xFFECECEC),
                        child: Icon(
                          Icons.person_outline,
                          color: AppColors.textSecondary,
                          size: 28.r,
                        ),
                      ),
              ),
            ],
          ),
          SizedBox(height: 12.h),
          // Inner Card: Details
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
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
                  AppStrings.contractDateLabel.tr(),
                  DateFormat(
                    'dd MMMM yyyy - HH:mm a',
                    'ar',
                  ).format(contract.date),
                ),
                SizedBox(height: 8.h),
                _buildDetailRow(
                  context,
                  AppStrings.contractLocationLabel.tr(),
                  contract.location,
                ),
                SizedBox(height: 8.h),
                Divider(color: AppColors.grey300, height: 1.h),
                SizedBox(height: 8.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        AppStrings.contractBudgetLabel.tr(),
                        style: TextStyle(
                          color: AppColors.textSecondary,
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
                            color: AppColors.gold,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          AppStrings.bookingCurrency.tr(),
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w400,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 12.h),
          // Pay Button
          SizedBox(
            width: double.infinity,
            height: 48.h,
            child: ElevatedButton(
              onPressed: () {
                context.read<ContractDetailsCubit>().payContract(contract.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
                elevation: 0,
              ),
              child: Text(
                AppStrings.contractPayNowAction.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          // Security Note
          Container(
            padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 13.h),
            decoration: ShapeDecoration(
              color: const Color(0x1917A2B8),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 1, color: Color(0x3316A2B8)),
                borderRadius: BorderRadius.circular(10.r),
              ),
            ),
            child: Text(
              AppStrings.contractPaymentSecureNote.tr(),
              style: TextStyle(
                color: AppColors.textSecondary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w400,
                fontFamily: 'Cairo',
                height: 1.63,
              ),
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
        Flexible(
          child: Text(
            label,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              fontFamily: 'Cairo',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              fontFamily: 'Cairo',
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
