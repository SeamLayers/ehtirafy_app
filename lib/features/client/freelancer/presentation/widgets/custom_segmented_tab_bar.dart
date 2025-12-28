import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';

class CustomSegmentedTabBar extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const CustomSegmentedTabBar({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: AppColors.grey200, width: 1.h),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildTabItem(0, AppStrings.freelancerProfilePortfolio.tr()),
              _buildTabItem(1, AppStrings.freelancerProfileServices.tr()),
              _buildTabItem(2, AppStrings.freelancerProfileReviews.tr()),
            ],
          ),
          Stack(
            children: [
              Container(height: 2.h, color: Colors.transparent),
              AnimatedAlign(
                alignment: AlignmentDirectional(
                  (selectedIndex -
                      1.0), // Maps 0->-1 (Start), 1->0 (Center), 2->1 (End)
                  0.0,
                ),
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
                child: FractionallySizedBox(
                  widthFactor: 1 / 3,
                  child: Container(height: 2.h, color: AppColors.gold),
                ),
              ),
            ],
          ),
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
          color: Colors.transparent,
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 300),
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.gold : const Color(0xFF888888),
              fontFamily: 'Cairo',
            ),
            child: Text(title, textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
