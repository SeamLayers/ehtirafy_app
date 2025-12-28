import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';

class RequestsFilterTab extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const RequestsFilterTab({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48.h,
      width: double.infinity,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: Color(0xFFE5E5E5)),
          borderRadius: BorderRadius.circular(12.r),
        ),
      ),
      child: Stack(
        children: [
          Row(
            children: [
              _buildTabItem(
                context,
                index: 2,
                title: AppStrings.myRequestsTabCompleted.tr(),
              ),
              _buildTabItem(
                context,
                index: 1,
                title: AppStrings.myRequestsTabUnderReview.tr(),
              ),
              _buildTabItem(
                context,
                index: 0,
                title: AppStrings.myRequestsTabActive.tr(),
              ),
            ],
          ),
          AnimatedAlign(
            alignment: _getAlignment(selectedIndex),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: FractionallySizedBox(
              widthFactor: 1 / 3,
              child: Container(
                height: 3.h,
                margin: EdgeInsets.only(top: 45.h), // Position at bottom
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(4.r),
                    topRight: Radius.circular(4.r),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  AlignmentGeometry _getAlignment(int index) {
    switch (index) {
      case 2:
        return AlignmentDirectional.centerStart;
      case 1:
        return AlignmentDirectional.center;
      case 0:
        return AlignmentDirectional.centerEnd;
      default:
        return AlignmentDirectional.centerEnd;
    }
  }

  Widget _buildTabItem(
    BuildContext context, {
    required int index,
    required String title,
  }) {
    final isSelected = selectedIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => onTabSelected(index),
        behavior: HitTestBehavior.opaque,
        child: Center(
          child: Text(
            title,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected ? AppColors.primary : const Color(0xFF888888),
              fontSize: 14.sp,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              height: 1.43,
            ),
          ),
        ),
      ),
    );
  }
}
