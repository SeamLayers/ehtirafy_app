import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
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

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: Colors.grey.shade600,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              SizedBox(width: 8.w),
              GestureDetector(
                onTap: () => _copyToClipboard(value, label),
                child: Icon(
                  Icons.content_copy,
                  size: 18.sp,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
          Divider(height: 1.h, color: Colors.grey.shade300),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.r),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.white, Colors.blue.shade50],
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              children: [
                Icon(
                  Icons.account_balance,
                  size: 28.sp,
                  color: Colors.blue.shade700,
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    'تفاصيل الحساب البنكي',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue.shade900,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 12.h),
            Divider(height: 1.h, color: Colors.grey.shade300),

            // Bank Details
            _buildDetailRow('اسم البنك', bankAccount.bankName),
            _buildDetailRow('اسم المالك', bankAccount.accountName),
            _buildDetailRow('رقم الحساب IBAN', bankAccount.iban),
            if (bankAccount.accountNumber != null)
              _buildDetailRow('رقم الحساب (اختياري)', bankAccount.accountNumber!),
            if (bankAccount.swiftCode != null)
              _buildDetailRow('رمز SWIFT (اختياري)', bankAccount.swiftCode!),
            if (bankAccount.branchCode != null)
              _buildDetailRow('رمز الفرع (اختياري)', bankAccount.branchCode!),

            // Warning Section
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8.r),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: Colors.orange.shade700,
                    size: 20.sp,
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'تأكد من نسخ البيانات بشكل صحيح قبل تحويل المبلغ',
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.orange.shade900,
                        height: 1.4,
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
