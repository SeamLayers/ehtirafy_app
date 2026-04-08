import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/backend_contract_status_ui.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/contract_header.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/contract_status_widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class OrderDetailsCompletedView extends StatelessWidget {
  final ContractDetailsEntity contract;

  const OrderDetailsCompletedView({super.key, required this.contract});

  String _fontFamily(BuildContext context) {
    return localizedContractStatusFontFamily(context);
  }

  @override
  Widget build(BuildContext context) {
    final isArabic =
        context.locale.languageCode.toLowerCase().startsWith('ar');

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContractHeader(contract: contract),
          SizedBox(height: 16.h),
          ContractThreeStatusCard(contract: contract),
          SizedBox(height: 16.h),
          _buildCompletionMessage(context),
          SizedBox(height: 16.h),
          // Rate Service Button
          _buildRateButton(context, isArabic: isArabic),
          SizedBox(height: 16.h),
          // Chat with photographer
          _buildChatButton(context, isArabic: isArabic),
        ],
      ),
    );
  }

  Widget _buildRateButton(BuildContext context, {required bool isArabic}) {
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
          isArabic ? 'تقييم الخدمة' : 'Rate Service',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            fontFamily: _fontFamily(context),
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

  Widget _buildChatButton(BuildContext context, {required bool isArabic}) {
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
          isArabic ? 'محادثة المصور' : 'Chat With Photographer',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily(context),
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

  Widget _buildCompletionMessage(BuildContext context) {
    final isArabic =
        context.locale.languageCode.toLowerCase().startsWith('ar');

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.success.withValues(alpha: 0.1),
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
            'Closed',
            style: TextStyle(
              color: AppColors.success,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            isArabic
                ? 'تم إغلاق العقد بعد اكتمال الخدمة بنجاح.'
                : 'The contract is now closed after successful completion.',
            style: TextStyle(color: AppColors.grey500, fontSize: 14.sp),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
