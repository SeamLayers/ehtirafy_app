import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/freelancer_entity.dart';

class FreelancerInfoCard extends StatelessWidget {
  final FreelancerEntity freelancer;

  const FreelancerInfoCard({super.key, required this.freelancer});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 50.h),
        Text(
          freelancer.name,
          style: TextStyle(
            fontSize: 20.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          freelancer.title,
          style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
        ),
        SizedBox(height: 8.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.location_on, size: 16.sp, color: AppColors.gold),
            SizedBox(width: 4.w),
            Text(
              freelancer.location,
              style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Text(
            freelancer.bio,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ),
        SizedBox(height: 16.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.star, color: Colors.amber, size: 20.sp),
            SizedBox(width: 4.w),
            Text(
              freelancer.rating.toString(),
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            SizedBox(width: 4.w),
            Text(
              AppStrings.freelancerProfileReviewsCount.tr(
                namedArgs: {'count': freelancer.reviewsCount.toString()},
              ),
              style: TextStyle(fontSize: 14.sp, color: AppColors.textSecondary),
            ),
          ],
        ),
      ],
    );
  }
}
