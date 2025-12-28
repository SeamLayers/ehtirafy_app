import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ProfileTile extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final bool isDestructive;
  final Widget? trailing;
  final Color? textColor;
  final Color? iconColor;

  const ProfileTile({
    super.key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.trailing,
    this.textColor,
    this.iconColor,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 58.h,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: ShapeDecoration(
          color: Colors.white,
          shape: RoundedRectangleBorder(
            side: BorderSide(
              width: isDestructive ? 2 : 1,
              color: isDestructive
                  ? const Color(0xFFDC3545)
                  : const Color(0xFFE5E5E5),
            ),
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8.w),
                    decoration: BoxDecoration(
                      color: (iconColor ?? const Color(0xFFC8A44F)).withOpacity(
                        0.1,
                      ),
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Icon(
                      icon,
                      color: iconColor ?? const Color(0xFFC8A44F),
                      size: 20.sp,
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: textColor ?? const Color(0xFF2B2B2B),
                        fontSize: 14.sp,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: isDestructive
                  ? const Color(0xFFDC3545)
                  : const Color(0xFF2B2B2B),
              size: 16.sp,
            ),
          ],
        ),
      ),
    );
  }
}
