import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../domain/entities/bank_account_entity.dart';

class BankDetailsCard extends StatelessWidget {
  final BankAccountEntity bankAccount;

  const BankDetailsCard({
    super.key,
    required this.bankAccount,
  });

  void _copyToClipboard(String text, String label) {
    Clipboard.setData(ClipboardData(text: text));
    Fluttertoast.showToast(
      msg: 'تم نسخ $label',
      toastLength: Toast.LENGTH_SHORT,
    );
  }

  Widget _buildDetailRow(
    String label,
    String value, {
    bool showDivider = true,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Row(
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              GestureDetector(
                onTap: () => _copyToClipboard(value, label),
                behavior: HitTestBehavior.opaque,
                child: Container(
                  padding: EdgeInsets.all(8.r),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  child: Icon(
                    Icons.content_copy_rounded,
                    size: 16.sp,
                    color: AppColors.gold,
                  ),
                ),
              ),
            ],
          ),
          if (showDivider) ...[
            SizedBox(height: AppSpacing.sm),
            Divider(height: 1.h, thickness: 1, color: AppColors.grey200),
          ],
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bool showAccountNumber = bankAccount.accountNumber != null;
    final bool showSwiftCode = bankAccount.swiftCode != null;
    final bool showBranchCode = bankAccount.branchCode != null;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
          const BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.r),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.gold.withValues(alpha: 0.18),
                        AppColors.gold.withValues(alpha: 0.08),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                  child: Icon(
                    Icons.account_balance_rounded,
                    size: 24.sp,
                    color: AppColors.gold,
                  ),
                ),
                SizedBox(width: AppSpacing.sm + 4.w),
                Expanded(
                  child: Text(
                    'تفاصيل الحساب البنكي',
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: AppColors.dark,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            Divider(height: 1.h, thickness: 1, color: AppColors.grey200),

            // Bank Details
            _buildDetailRow('اسم البنك', bankAccount.bankName),
            _buildDetailRow('اسم المالك', bankAccount.accountName),
            _buildDetailRow(
              'رقم الحساب IBAN',
              bankAccount.iban,
              showDivider:
                  showAccountNumber || showSwiftCode || showBranchCode,
            ),
            if (showAccountNumber)
              _buildDetailRow(
                'رقم الحساب (اختياري)',
                bankAccount.accountNumber!,
                showDivider: showSwiftCode || showBranchCode,
              ),
            if (showSwiftCode)
              _buildDetailRow(
                'رمز SWIFT (اختياري)',
                bankAccount.swiftCode!,
                showDivider: showBranchCode,
              ),
            if (showBranchCode)
              _buildDetailRow(
                'رمز الفرع (اختياري)',
                bankAccount.branchCode!,
                showDivider: false,
              ),

            // Warning Section
            SizedBox(height: AppSpacing.md),
            Container(
              padding: EdgeInsets.all(AppSpacing.sm + 4.w),
              decoration: BoxDecoration(
                color: AppColors.warning.withValues(alpha: 0.10),
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(
                  color: AppColors.warning.withValues(alpha: 0.30),
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline_rounded,
                    color: AppColors.warning,
                    size: 20.sp,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Text(
                      'تأكد من نسخ البيانات بشكل صحيح قبل تحويل المبلغ',
                      style: TextStyle(
                        fontFamily: 'Cairo',
                        fontSize: 12.sp,
                        color: AppColors.textPrimary,
                        height: 1.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
