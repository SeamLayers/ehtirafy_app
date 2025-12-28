import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';

class FreelancerCustomTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const FreelancerCustomTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        children: [
          _buildTabItem(0, AppStrings.freelancerProfilePortfolio.tr()),
          _buildTabItem(1, AppStrings.freelancerProfileServices.tr()),
          _buildTabItem(2, AppStrings.freelancerProfileReviews.tr()),
        ],
      ),
    );
  }

  Widget _buildTabItem(int index, String title) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: BoxDecoration(
            border: isSelected
                ? Border(
                    bottom: BorderSide(color: AppColors.gold, width: 3.h),
                  )
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.gold : AppColors.textSecondary,
              fontFamily: 'Cairo',
            ),
          ),
        ),
      ),
    );
  }
}
