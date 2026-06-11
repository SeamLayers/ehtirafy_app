import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/freelancer_entity.dart';

class FreelancerHeader extends StatelessWidget {
  final FreelancerEntity freelancer;

  const FreelancerHeader({super.key, required this.freelancer});

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomCenter,
      children: [
        // Gold gradient banner with a soft, premium shadow.
        Container(
          height: 120.h,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                AppColors.gold,
                AppColors.gold.withValues(alpha: 0.82),
                AppColors.dark.withValues(alpha: 0.55),
              ],
              stops: const [0.0, 0.55, 1.0],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(28.r),
              bottomRight: Radius.circular(28.r),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.25),
                blurRadius: 18.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
        ),
        Positioned(
          bottom: -40.h,
          child: Container(
            padding: EdgeInsets.all(AppSpacing.xs),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: AppColors.dark.withValues(alpha: 0.12),
                  blurRadius: 16.r,
                  offset: Offset(0, 6.h),
                ),
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.18),
                  blurRadius: 12.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            // Initials-based avatar instead of network image
            child: Container(
              width: 84.r,
              height: 84.r,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [AppColors.textPrimary, Color(0xFF3D3D3D)],
                ),
                border: Border.all(
                  color: AppColors.gold.withValues(alpha: 0.45),
                  width: 1.5.w,
                ),
              ),
              child: Center(
                child: Text(
                  _getInitials(freelancer.name),
                  style: TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.gold,
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
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
