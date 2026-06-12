import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Secure-escrow visual for the contract payment.
///
/// Renders a shield/lock "vault" hero with a gold-tinted accent, the existing
/// bilingual "amount safely held" copy, and a deposited vs pending state that is
/// driven entirely by [ContractDetailsEntity.isPaymentDeposited].
class PaymentStatusCard extends StatelessWidget {
  final ContractDetailsEntity contract;

  const PaymentStatusCard({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    final bool isDeposited = contract.isPaymentDeposited;
    final bool isArabic = context.locale.languageCode == 'ar';

    // Accent tone: success (green) once the escrow is funded, gold while pending.
    final Color accent = isDeposited ? AppColors.success : AppColors.gold;
    final IconData vaultIcon = isDeposited
        ? Icons.verified_user_rounded
        : Icons.lock_clock_rounded;

    return Container(
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 18.r,
            offset: Offset(0, 6.h),
            spreadRadius: -2.r,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---- Header: rounded icon badge + section label ----
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.shield_rounded,
                  color: accent,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: AppSpacing.sm + 2.w),
              Expanded(
                child: Text(
                  AppStrings.contractPaymentStatusLabel.tr(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              _StatusPill(
                isDeposited: isDeposited,
                isArabic: isArabic,
                accent: accent,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),

          // ---- Escrow hero: vault icon + amount safely held ----
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.07),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(color: accent.withValues(alpha: 0.25)),
              boxShadow: [
                BoxShadow(
                  color: accent.withValues(alpha: 0.10),
                  blurRadius: 16.r,
                  offset: Offset(0, 6.h),
                  spreadRadius: -4.r,
                ),
              ],
            ),
            child: Row(
              children: [
                // Vault / shield node
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: accent,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: accent.withValues(alpha: 0.35),
                        blurRadius: 10.r,
                        offset: Offset(0, 3.h),
                      ),
                    ],
                  ),
                  child: Icon(
                    vaultIcon,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: AppSpacing.sm + 2.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        isDeposited
                            ? AppStrings.contractPaymentStatusDeposited.tr()
                            : (isArabic
                                ? 'بانتظار إيداع المبلغ في الضمان'
                                : 'Awaiting deposit into escrow'),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w700,
                          height: 1.35,
                          fontFamily: 'Cairo',
                        ),
                      ),
                      SizedBox(height: 6.h),
                      // Amount block
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: [
                          Text(
                            NumberFormat('#,###').format(contract.budget),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: accent,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'Cairo',
                            ),
                          ),
                          SizedBox(width: 5.w),
                          Text(
                            AppStrings.bookingCurrency.tr(),
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
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
          SizedBox(height: AppSpacing.sm + 2.h),

          // ---- Secure footer: lock icon + reassurance copy ----
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                color: AppColors.textSecondary,
                size: 14.sp,
              ),
              SizedBox(width: 6.w),
              Expanded(
                child: Text(
                  AppStrings.contractPaymentSecureMessage.tr(),
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 12.sp,
                    height: 1.4,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// Small deposited / pending pill shown in the card header.
class _StatusPill extends StatelessWidget {
  final bool isDeposited;
  final bool isArabic;
  final Color accent;

  const _StatusPill({
    required this.isDeposited,
    required this.isArabic,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final String label = isDeposited
        ? (isArabic ? 'محفوظ' : 'Secured')
        : (isArabic ? 'قيد الانتظار' : 'Pending');
    final IconData icon =
        isDeposited ? Icons.check_circle_rounded : Icons.schedule_rounded;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: accent.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: accent, size: 14.r),
          SizedBox(width: 5.w),
          Text(
            label,
            style: TextStyle(
              color: accent,
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
