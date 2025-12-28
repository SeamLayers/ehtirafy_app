import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TransactionTile extends StatelessWidget {
  final String title;
  final String date;
  final double amount;
  final bool isCredit;
  final String status;

  const TransactionTile({
    super.key,
    required this.title,
    required this.date,
    required this.amount,
    required this.isCredit,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12.h),
      padding: EdgeInsets.all(16.w),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE5E5E5)),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: ShapeDecoration(
                  color: isCredit
                      ? const Color(0xFFE8F5E9)
                      : const Color(0xFFFFEBEE),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                ),
                child: Icon(
                  isCredit ? Icons.arrow_downward : Icons.arrow_upward,
                  color: isCredit
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFF44336),
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: const Color(0xFF2B2B2B),
                      fontSize: 14.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    date,
                    style: TextStyle(
                      color: const Color(0xFF888888),
                      fontSize: 12.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isCredit ? '+' : '-'} $amount ${'currency'.tr()}',
                style: TextStyle(
                  color: isCredit
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFF44336),
                  fontSize: 14.sp,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                status,
                style: TextStyle(
                  color: const Color(0xFF888888),
                  fontSize: 12.sp,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
