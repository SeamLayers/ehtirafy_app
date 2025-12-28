import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../domain/entities/user_profile_entity.dart';

class ProfileHeader extends StatelessWidget {
  final UserProfileEntity user;

  const ProfileHeader({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: const Color(0xFFE5E5E5)),
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Avatar - Using initials instead of photo
            Container(
              width: 80.w,
              height: 80.w,
              decoration: ShapeDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFC8A44F), Color(0xFFD4AF37)],
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                shadows: [
                  BoxShadow(
                    color: const Color(0x19000000),
                    blurRadius: 6,
                    offset: const Offset(0, 4),
                    spreadRadius: -4,
                  ),
                  BoxShadow(
                    color: const Color(0x19000000),
                    blurRadius: 15,
                    offset: const Offset(0, 10),
                    spreadRadius: -3,
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  _getInitials(user.name),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 8.h),
                  Text(
                    user.name,
                    style: TextStyle(
                      color: const Color(0xFF0A0A0A),
                      fontSize: 16.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  Text(
                    user.email,
                    style: TextStyle(
                      color: const Color(0xFF888888),
                      fontSize: 14.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                      height: 1.50,
                    ),
                  ),
                  if (user.currentRole == UserRole.freelancer) ...[
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Text(
                          '★ ${user.rating}',
                          style: TextStyle(
                            color: const Color(0xFFC8A44F),
                            fontSize: 14.sp,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '(${user.reviewCount} تقييم)',
                          style: TextStyle(
                            color: const Color(0xFF888888),
                            fontSize: 14.sp,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}
