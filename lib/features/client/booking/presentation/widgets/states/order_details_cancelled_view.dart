import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/contract_header.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/contract_status_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsCancelledView extends StatelessWidget {
  final ContractDetailsEntity contract;

  const OrderDetailsCancelledView({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    final isArabic =
        context.locale.languageCode.toLowerCase().startsWith('ar');

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContractHeader(contract: contract),
          SizedBox(height: AppSpacing.md),
          ContractThreeStatusCard(contract: contract),
          SizedBox(height: AppSpacing.md),
          _buildCancelledMessage(isArabic: isArabic),
        ],
      ),
    );
  }

  Widget _buildCancelledMessage({required bool isArabic}) {
    final isRejected = contract.status == ContractStatus.rejected;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.error.withValues(alpha: 0.10),
            AppColors.error.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.error.withValues(alpha: 0.35)),
        boxShadow: [
          BoxShadow(
            color: AppColors.error.withValues(alpha: 0.08),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 72.w,
            height: 72.w,
            decoration: BoxDecoration(
              color: AppColors.error.withValues(alpha: 0.12),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.error.withValues(alpha: 0.25),
              ),
            ),
            child: Icon(
              Icons.cancel_outlined,
              color: AppColors.error,
              size: 38.sp,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            isRejected ? 'Rejected' : 'Cancelled',
            style: TextStyle(
              fontFamily: 'Cairo',
              color: AppColors.error,
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            isRejected
                ? (isArabic
                      ? 'تم رفض العقد من طرف المصور.'
                      : 'The contract was rejected by the freelancer.')
                : (isArabic
                      ? 'تم إلغاء العقد.'
                      : 'The contract was cancelled.'),
            style: TextStyle(
              fontFamily: 'Cairo',
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              height: 1.5,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
