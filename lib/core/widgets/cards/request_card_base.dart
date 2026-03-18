import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RequestCardBase extends StatelessWidget {
  final VoidCallback onTap;
  final Widget avatar;
  final Widget title;
  final Widget subtitle;
  final Widget statusBadge;
  final Widget price;
  final Widget timeAgo;
  final Widget? footer;

  const RequestCardBase({
    super.key,
    required this.onTap,
    required this.avatar,
    required this.title,
    required this.subtitle,
    required this.statusBadge,
    required this.price,
    required this.timeAgo,
    this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: const [
            BoxShadow(
              color: Color(0x0D000000),
              blurRadius: 10,
              offset: Offset(0, 4),
              spreadRadius: 0,
            ),
          ],
          border: Border.all(color: const Color(0xFFF2F2F2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                avatar,
                SizedBox(width: 16.w),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      title,
                      SizedBox(height: 8.h),
                      subtitle,
                      SizedBox(height: 8.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [statusBadge, price],
                      ),
                      SizedBox(height: 8.h),
                      timeAgo,
                    ],
                  ),
                ),
              ],
            ),
            if (footer != null) ...[
              SizedBox(height: 16.h),
              footer!,
            ],
          ],
        ),
      ),
    );
  }
}