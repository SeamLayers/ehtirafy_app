import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';

class ClientBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const ClientBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        border: Border(
          top: BorderSide(
            color: AppColors.grey200.withValues(alpha: 0.8),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 20.r,
            offset: Offset(0, -6.h),
          ),
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 10.r,
            offset: Offset(0, -2.h),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 10.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // RTL: the first item (Home) renders right-most, the last (More)
            // left-most — matching the required right-to-left tab order:
            // Home · Search · Contracts & Chats · Profile · More.
            children: [
              _buildNavItem(
                context: context,
                index: 0,
                icon: Icons.home_outlined,
                activeIcon: Icons.home_filled,
                label: AppStrings.navHome.tr(),
              ),
              _buildNavItem(
                context: context,
                index: 1,
                icon: Icons.search_outlined,
                activeIcon: Icons.search,
                label: AppStrings.navSearch.tr(),
              ),
              _buildNavItem(
                context: context,
                index: 2,
                icon: Icons.handshake_outlined,
                activeIcon: Icons.handshake,
                label: AppStrings.navContractsChats.tr(),
              ),
              _buildNavItem(
                context: context,
                index: 3,
                icon: Icons.person_outline,
                activeIcon: Icons.person,
                label: AppStrings.navProfile.tr(),
              ),
              _buildNavItem(
                context: context,
                index: 4,
                icon: Icons.more_horiz_outlined,
                activeIcon: Icons.more_horiz,
                label: AppStrings.navMore.tr(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required BuildContext context,
    required int index,
    required IconData icon,
    required IconData activeIcon,
    required String label,
  }) {
    final isActive = currentIndex == index;

    return Expanded(
      child: InkWell(
        onTap: () => onTap(index),
        borderRadius: BorderRadius.circular(16.r),
        splashColor: AppColors.primary.withValues(alpha: 0.08),
        highlightColor: AppColors.primary.withValues(alpha: 0.04),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(horizontal: 3.w, vertical: 8.h),
          decoration: isActive
              ? BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      AppColors.primary.withValues(alpha: 0.14),
                      AppColors.primary.withValues(alpha: 0.06),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16.r),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.18),
                    width: 1,
                  ),
                )
              : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedScale(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOut,
                scale: isActive ? 1.08 : 1.0,
                child: Icon(
                  isActive ? activeIcon : icon,
                  color: isActive ? AppColors.primary : AppColors.grey500,
                  size: 22.sp,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                label,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isActive ? AppColors.primary : AppColors.grey500,
                  fontSize: 9.5.sp,
                  fontWeight: isActive ? FontWeight.w700 : FontWeight.w500,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
