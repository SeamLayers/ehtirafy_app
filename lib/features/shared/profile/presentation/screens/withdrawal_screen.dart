import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class WithdrawalScreen extends StatefulWidget {
  const WithdrawalScreen({super.key});

  @override
  State<WithdrawalScreen> createState() => _WithdrawalScreenState();
}

class _WithdrawalScreenState extends State<WithdrawalScreen> {
  final TextEditingController _amountController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2B2B),
        elevation: 0,
        title: Text(
          'wallet.withdraw'.tr(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontFamily: 'Cairo',
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.pop(),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(24.r),
            bottomRight: Radius.circular(24.r),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Amount Input
            Text(
              'wallet.withdrawal_amount'.tr(),
              style: TextStyle(
                color: const Color(0xFF0A0A0A),
                fontSize: 14.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
              decoration: ShapeDecoration(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  side: const BorderSide(width: 1, color: Color(0xFFE5E5E5)),
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _amountController,
                      keyboardType: TextInputType.number,
                      style: TextStyle(
                        color: const Color(0xFF0A0A0A),
                        fontSize: 16.sp,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                      ),
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: '0.00',
                        hintStyle: TextStyle(
                          color: const Color(0xFF888888),
                          fontSize: 16.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ),
                  Text(
                    'currency'.tr(),
                    style: TextStyle(
                      color: const Color(0xFF888888),
                      fontSize: 14.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              '${'wallet.available_balance'.tr()}: 2,450.00 ${'currency'.tr()}',
              style: TextStyle(
                color: const Color(0xFF888888),
                fontSize: 12.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w400,
              ),
            ),
            SizedBox(height: 32.h),

            // Bank Details (Mock)
            Text(
              'wallet.bank_account'.tr(),
              style: TextStyle(
                color: const Color(0xFF0A0A0A),
                fontSize: 14.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: ShapeDecoration(
                color: const Color(0xFFF3F3F5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.r),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Al Rajhi Bank',
                    style: TextStyle(
                      color: const Color(0xFF2B2B2B),
                      fontSize: 16.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    'SA56 8000 0000 0000 0000 0000',
                    style: TextStyle(
                      color: const Color(0xFF888888),
                      fontSize: 14.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                      letterSpacing: 1,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 40.h),

            // Confirm Button
            SizedBox(
              width: double.infinity,
              height: 50.h,
              child: ElevatedButton(
                onPressed: () {
                  // Withdrawal Logic
                  context.pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('wallet.withdrawal_success'.tr())),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFC8A44F),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.r),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  'confirm'.tr(),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
