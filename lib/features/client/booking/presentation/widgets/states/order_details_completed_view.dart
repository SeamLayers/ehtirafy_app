import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/backend_contract_status_ui.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/contract_header.dart';
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
          _buildCompletionMessage(context, isArabic: isArabic),
          SizedBox(height: AppSpacing.md),
          _buildSummaryCard(context, isArabic: isArabic),
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

  /// Celebratory closed/completed emblem with the existing bilingual copy.
  Widget _buildCompletionMessage(
    BuildContext context, {
    required bool isArabic,
  }) {
    final canonical = canonicalBackendContractStatus(
      contract.contractStatus ?? contract.status.name,
    );
    final ui = backendContractStatusUi(canonical);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg - AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            ui.color.withValues(alpha: 0.12),
            Colors.white,
          ],
        ),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(color: ui.color.withValues(alpha: 0.30)),
        boxShadow: [
          const BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 18,
            offset: Offset(0, 6),
            spreadRadius: -2,
          ),
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.10),
            blurRadius: 20,
            offset: const Offset(0, 8),
            spreadRadius: -4,
          ),
        ],
      ),
      child: Column(
        children: [
          // Large rounded success emblem with a gold ring halo.
          Container(
            width: 92.w,
            height: 92.w,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: SweepGradient(
                colors: [
                  AppColors.gold.withValues(alpha: 0.0),
                  AppColors.gold.withValues(alpha: 0.35),
                  AppColors.gold.withValues(alpha: 0.0),
                ],
              ),
            ),
            child: Center(
              child: Container(
                width: 78.w,
                height: 78.w,
                decoration: BoxDecoration(
                  color: ui.softColor,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: ui.color.withValues(alpha: 0.35),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: ui.color.withValues(alpha: 0.18),
                      blurRadius: 14,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Icon(
                  ui.icon,
                  color: ui.color,
                  size: 42.sp,
                ),
              ),
            ),
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            isArabic ? 'تم بنجاح' : 'Completed',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: ui.color,
              fontSize: 20.sp,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.3,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          // Bilingual "Closed" sub-label tied to backend status.
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: ui.softColor,
              borderRadius: BorderRadius.circular(10.r),
              border: Border.all(color: ui.color.withValues(alpha: 0.25)),
            ),
            child: Text(
              isArabic ? 'مغلق' : 'Closed',
              style: TextStyle(
                fontFamily: 'Cairo',
                color: ui.color,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          SizedBox(height: AppSpacing.sm),
          Text(
            isArabic
                ? 'تم إغلاق العقد بعد اكتمال الخدمة بنجاح.'
                : 'The contract is now closed after successful completion.',
            style: TextStyle(
              fontFamily: _fontFamily(context),
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

  /// Compact contract summary (date / location / budget) for the closed state.
  Widget _buildSummaryCard(BuildContext context, {required bool isArabic}) {
    final localeCode = isArabic ? 'ar' : 'en';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 16,
            offset: Offset(0, 6),
            spreadRadius: -2,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryRow(
            icon: Icons.event_available_rounded,
            label: AppStrings.contractDateLabel.tr(),
            value: DateFormat('dd MMMM yyyy', localeCode).format(contract.date),
          ),
          _summaryDivider(),
          _buildSummaryRow(
            icon: Icons.place_rounded,
            label: AppStrings.contractLocationLabel.tr(),
            value: contract.location,
          ),
          SizedBox(height: AppSpacing.sm + AppSpacing.xs),
          // Gold-tinted budget highlight.
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.08),
              border: Border.all(color: AppColors.gold.withValues(alpha: 0.25)),
              borderRadius: BorderRadius.circular(14.r),
            ),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.14),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.payments_rounded,
                    color: AppColors.gold,
                    size: 18.sp,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Text(
                    AppStrings.contractBudgetLabel.tr(),
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      color: AppColors.textSecondary,
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Flexible(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        contract.budget.toStringAsFixed(0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.gold,
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        AppStrings.bookingCurrency.tr(),
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          color: AppColors.textSecondary,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
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

  Widget _buildSummaryRow({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: EdgeInsets.all(8.w),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.10),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: AppColors.gold, size: 18.sp),
        ),
        SizedBox(width: AppSpacing.sm),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Cairo',
            color: AppColors.textSecondary,
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: Text(
            value,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.end,
            style: TextStyle(
              fontFamily: 'Cairo',
              color: AppColors.textPrimary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  Widget _summaryDivider() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: const Divider(height: 1, color: AppColors.grey200),
    );
  }

  Widget _buildRateButton(BuildContext context, {required bool isArabic}) {
    return Container(
      width: double.infinity,
      height: 52.h,
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
}
