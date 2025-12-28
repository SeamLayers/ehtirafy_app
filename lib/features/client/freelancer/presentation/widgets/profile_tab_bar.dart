import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';

class ProfileTabBar extends StatelessWidget {
  final TabController tabController;

  const ProfileTabBar({super.key, required this.tabController});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 24.w),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: AppColors.grey100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: TabBar(
        controller: tabController,
        indicator: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        labelColor: AppColors.gold,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.normal,
          fontFamily: 'Cairo',
        ),
        tabs: [
          Tab(text: AppStrings.freelancerProfilePortfolio.tr()),
          Tab(text: AppStrings.freelancerProfileServices.tr()),
          Tab(text: AppStrings.freelancerProfileReviews.tr()),
        ],
      ),
    );
  }
}
