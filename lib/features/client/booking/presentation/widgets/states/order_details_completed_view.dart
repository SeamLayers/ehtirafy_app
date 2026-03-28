import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/contract_header.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/contract_status_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OrderDetailsCompletedView extends StatelessWidget {
  final ContractDetailsEntity contract;

  const OrderDetailsCompletedView({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContractHeader(contract: contract),
          SizedBox(height: 16.h),
          ContractThreeStatusCard(contract: contract),
          SizedBox(height: 16.h),
          _buildCompletionMessage(),
          SizedBox(height: 16.h),
          // Rate Service Button
          _buildRateButton(context),
          SizedBox(height: 16.h),
          // Chat with photographer
          _buildChatButton(context),
        ],
      ),
    );
  }

  Widget _buildRateButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton.icon(
        onPressed: () {
          context.push(
            '/rate-service',
            extra: {
              'freelancerId': contract.publisherId,
              'freelancerName': contract.photographerName,
              'serviceName': contract.serviceTitle,
              'advertisementId': contract.advertisementId,
            },
          );
        },
        icon: Icon(Icons.star_rounded, size: 24.sp),
        label: Text(
          'تقييم الخدمة',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cairo',
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
          elevation: 0,
        ),
      ),
    );
  }

  Widget _buildChatButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48.h,
      child: OutlinedButton.icon(
        onPressed: () {
          context.push(
            '/chat/conversation',
            extra: {
              'id': contract.id.toString(),
              'name': contract.photographerName,
              'image': contract.photographerImage,
              'userType': 'customer',
            },
          );
        },
        icon: Icon(Icons.chat_bubble_outline, size: 20.sp),
        label: Text(
          'محادثة المصور',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            fontFamily: 'Cairo',
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.gold,
          side: const BorderSide(color: AppColors.gold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      ),
    );
  }

  Widget _buildCompletionMessage() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.success),
      ),
      child: Column(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: AppColors.success,
            size: 48.sp,
          ),
          SizedBox(height: 12.h),
          Text(
            AppStrings.contractValCompleted.tr(),
            style: TextStyle(
              color: AppColors.success,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'تم اكتمال هذا العقد بنجاح', // Could localize this if needed
            style: TextStyle(color: AppColors.grey500, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
