import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../widgets/transaction_tile.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2B2B2B),
        elevation: 0,
        title: Text(
          'wallet.title'.tr(),
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
            // Balance Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(24.w),
              decoration: ShapeDecoration(
                gradient: const LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [Color(0xFFC8A44F), Color(0xFF9D7B2A)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
                shadows: [
                  BoxShadow(
                    color: const Color(0x33C8A44F),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                    spreadRadius: 0,
                  ),
                ],
              ),
              child: Column(
                children: [
                  Text(
                    'wallet.total_balance'.tr(),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    '2,450.00 ${'currency'.tr()}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  InkWell(
                    onTap: () {
                      context.push('/profile/wallet/withdraw');
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 24.w,
                        vertical: 12.h,
                      ),
                      decoration: ShapeDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.account_balance_wallet_outlined,
                            color: Colors.white,
                            size: 20.sp,
                          ),
                          SizedBox(width: 8.w),
                          Text(
                            'wallet.withdraw'.tr(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),

            // Transactions Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'wallet.recent_transactions'.tr(),
                  style: TextStyle(
                    color: const Color(0xFF2B2B2B),
                    fontSize: 16.sp,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                TextButton(
                  onPressed: () {},
                  child: Text(
                    'view_all'.tr(),
                    style: TextStyle(
                      color: const Color(0xFFC8A44F),
                      fontSize: 14.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.h),

            // Transactions List
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: 5,
              itemBuilder: (context, index) {
                return TransactionTile(
                  title: index % 2 == 0
                      ? 'wallet.deposit_from_client'.tr()
                      : 'wallet.withdrawal'.tr(),
                  date: '2023-10-${10 + index}',
                  amount: (index + 1) * 150.0,
                  isCredit: index % 2 == 0,
                  status: 'wallet.status_completed'.tr(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
