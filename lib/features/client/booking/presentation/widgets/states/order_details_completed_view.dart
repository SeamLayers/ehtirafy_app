import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
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
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContractHeader(contract: contract),
          SizedBox(height: AppSpacing.md),
          ContractThreeStatusCard(contract: contract),
          SizedBox(height: AppSpacing.md),
          _buildCompletionMessage(context),
          SizedBox(height: AppSpacing.md),
          // Rate Service Button
          _buildRateButton(context, isArabic: isArabic),
          SizedBox(height: AppSpacing.sm + AppSpacing.xs),
          // Chat with photographer
          _buildChatButton(context, isArabic: isArabic),
        ],
      ),
    );
  }

  Widget _buildRateButton(BuildContext context, {required bool isArabic}) {
    return Container(
      width: double.infinity,
      height: 54.h,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFC8A44F), Color(0xFFB8944F)],
        ),
        borderRadius: BorderRadius.circular(14.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.28),
            blurRadius: 14,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(14.r),
          onTap: () {
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.star_rounded,
                size: 24.sp,
                color: Colors.white,
              ),
              SizedBox(width: AppSpacing.sm),
              Flexible(
                child: Text(
                  isArabic ? 'تقييم الخدمة' : 'Rate Service',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: _fontFamily(context),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatButton(BuildContext context, {required bool isArabic}) {
    return SizedBox(
      width: double.infinity,
      height: 50.h,
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
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            fontFamily: _fontFamily(context),
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.gold,
          backgroundColor: AppColors.gold.withValues(alpha: 0.04),
          side: BorderSide(color: AppColors.gold.withValues(alpha: 0.6)),
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
      padding: EdgeInsets.all(AppSpacing.lg - AppSpacing.xs),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.success.withValues(alpha: 0.12),
            AppColors.success.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.success.withValues(alpha: 0.4)),
        boxShadow: [
          BoxShadow(
            color: AppColors.success.withValues(alpha: 0.12),
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
              color: AppColors.success.withValues(alpha: 0.14),
              shape: BoxShape.circle,
              border: Border.all(
                color: AppColors.success.withValues(alpha: 0.3),
                width: 1.5,
              ),
            ),
            child: Icon(
              Icons.check_circle_outline,
              color: AppColors.success,
              size: 40.sp,
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            'Closed',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: AppColors.success,
              fontSize: 19.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            isArabic
                ? 'تم إغلاق العقد بعد اكتمال الخدمة بنجاح.'
                : 'The contract is now closed after successful completion.',
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
