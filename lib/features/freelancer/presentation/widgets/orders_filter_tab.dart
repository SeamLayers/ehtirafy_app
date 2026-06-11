import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';

class OrdersFilterTab extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onTabSelected;

  const OrdersFilterTab({
    super.key,
    required this.selectedIndex,
    required this.onTabSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52.h,
      width: double.infinity,
      padding: EdgeInsets.all(AppSpacing.xs),
      decoration: ShapeDecoration(
        color: AppColors.grey100,
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: AppColors.grey200),
          borderRadius: BorderRadius.circular(16.r),
        ),
        shadows: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            alignment: _getAlignment(selectedIndex),
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: FractionallySizedBox(
              widthFactor: 1 / 3,
              heightFactor: 1,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    width: 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.18),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Row(
            children: [
              _buildTabItem(
                context,
                index: 2,
                title: AppStrings.freelancerOrdersTabArchived.tr(),
              ),
              _buildTabItem(
                context,
                index: 1,
                title: AppStrings.freelancerOrdersTabActive.tr(),
              ),
              _buildTabItem(
                context,
                index: 0,
                title: AppStrings.freelancerOrdersTabRequests.tr(),
              ),
            ],
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
          child: AnimatedDefaultTextStyle(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontSize: 14.sp,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                  height: 1.43,
                ) ??
                TextStyle(
                  color: isSelected
                      ? AppColors.primary
                      : AppColors.textSecondary,
                  fontSize: 14.sp,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w500,
                ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.xs),
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
