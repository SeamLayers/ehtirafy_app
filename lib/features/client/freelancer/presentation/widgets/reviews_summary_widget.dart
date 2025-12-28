import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';

class ReviewsSummaryWidget extends StatelessWidget {
  final double rating;
  final int reviewsCount;
  final Map<int, double> ratingDistribution;

  const ReviewsSummaryWidget({
    super.key,
    required this.rating,
    required this.reviewsCount,
    required this.ratingDistribution,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          // Left Side: Progress Bars
          Expanded(
            flex: 3,
            child: Column(
              children: [
                _buildRatingBar(5, ratingDistribution[5] ?? 0),
                SizedBox(height: 4.h),
                _buildRatingBar(4, ratingDistribution[4] ?? 0),
                SizedBox(height: 4.h),
                _buildRatingBar(3, ratingDistribution[3] ?? 0),
                SizedBox(height: 4.h),
                _buildRatingBar(2, ratingDistribution[2] ?? 0),
                SizedBox(height: 4.h),
                _buildRatingBar(1, ratingDistribution[1] ?? 0),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          // Right Side: Big Rating
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  rating.toString(),
                  style: TextStyle(
                    fontSize: 32.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gold,
                    height: 1,
                  ),
                ),
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    return Icon(
                      index < rating.round() ? Icons.star : Icons.star_border,
                      color: AppColors.gold,
                      size: 16.sp,
                    );
                  }),
                ),
                SizedBox(height: 4.h),
                Text(
                  AppStrings.freelancerProfileReviewsCount.tr(
                    namedArgs: {'count': reviewsCount.toString()},
                  ),
                  style: TextStyle(
                    fontSize: 12.sp,
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingBar(int star, double percentage) {
    return Row(
      children: [
        Text(
          star.toString(),
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2B2B2B),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.r),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: AppColors.grey100,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
              minHeight: 6.h,
            ),
          ),
        ),
      ],
    );
  }
}
