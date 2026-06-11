import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
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
      padding: EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.grey200, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.06),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
          const BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Big Rating
            Expanded(
              flex: 2,
              child: _buildBigRating(context),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: const VerticalDivider(
                width: 1,
                thickness: 1,
                color: AppColors.grey200,
              ),
            ),
            // Progress Bars
            Expanded(
              flex: 3,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildRatingBar(5, ratingDistribution[5] ?? 0),
                  SizedBox(height: AppSpacing.sm),
                  _buildRatingBar(4, ratingDistribution[4] ?? 0),
                  SizedBox(height: AppSpacing.sm),
                  _buildRatingBar(3, ratingDistribution[3] ?? 0),
                  SizedBox(height: AppSpacing.sm),
                  _buildRatingBar(2, ratingDistribution[2] ?? 0),
                  SizedBox(height: AppSpacing.sm),
                  _buildRatingBar(1, ratingDistribution[1] ?? 0),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBigRating(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          rating.toString(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 40.sp,
            fontWeight: FontWeight.w800,
            color: AppColors.gold,
            height: 1,
          ),
        ),
        SizedBox(height: AppSpacing.sm),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(5, (index) {
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 1.w),
              child: Icon(
                index < rating.round() ? Icons.star_rounded : Icons.star_outline_rounded,
                color: AppColors.gold,
                size: 18.sp,
              ),
            );
          }),
        ),
        SizedBox(height: AppSpacing.xs),
        Text(
          AppStrings.freelancerProfileReviewsCount.tr(
            namedArgs: {'count': reviewsCount.toString()},
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontFamily: 'Cairo',
            fontSize: 12.sp,
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildRatingBar(int star, double percentage) {
    return Row(
      children: [
        SizedBox(
          width: 12.w,
          child: Text(
            star.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 12.sp,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        SizedBox(width: AppSpacing.xs),
        Icon(
          Icons.star_rounded,
          size: 13.sp,
          color: AppColors.gold,
        ),
        SizedBox(width: AppSpacing.sm),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(6.r),
            child: LinearProgressIndicator(
              value: percentage,
              backgroundColor: AppColors.grey100,
              valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
              minHeight: 8.h,
            ),
          ),
        ),
      ],
    );
  }
}
