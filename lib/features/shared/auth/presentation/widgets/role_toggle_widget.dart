import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../core/theme/app_colors.dart';

/// Role Toggle Widget for Signup Screen
/// Allows user to toggle between Freelancer and Client roles
class RoleToggleWidget extends StatelessWidget {
  final bool isFreelancer;
  final ValueChanged<bool> onChanged;

  const RoleToggleWidget({
    super.key,
    required this.isFreelancer,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: isDark ? AppColors.grey800 : AppColors.grey100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Row(
        children: [
          // Client Option
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: !isFreelancer
                      ? AppColors.gold
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: !isFreelancer
                      ? [
                          BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.person_search_rounded,
                        size: 20.sp,
                        color: !isFreelancer
                            ? Colors.white
                            : (isDark ? AppColors.grey400 : AppColors.grey600),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Client',
                        style: GoogleFonts.cairo(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: !isFreelancer
                              ? Colors.white
                              : (isDark ? AppColors.grey400 : AppColors.grey600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Freelancer Option
          Expanded(
            child: GestureDetector(
              onTap: () => onChanged(true),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  color: isFreelancer
                      ? AppColors.gold
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(10.r),
                  boxShadow: isFreelancer
                      ? [
                          BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ]
                      : null,
                ),
                child: Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.camera_alt_rounded,
                        size: 20.sp,
                        color: isFreelancer
                            ? Colors.white
                            : (isDark ? AppColors.grey400 : AppColors.grey600),
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Freelancer',
                        style: GoogleFonts.cairo(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: isFreelancer
                              ? Colors.white
                              : (isDark ? AppColors.grey400 : AppColors.grey600),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
