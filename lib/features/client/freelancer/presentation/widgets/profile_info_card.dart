import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/freelancer_entity.dart';

class ProfileInfoCard extends StatelessWidget {
  final FreelancerEntity freelancer;

  const ProfileInfoCard({super.key, required this.freelancer});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Profile Image & Basic Info
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Image (Rounded Square)
              Container(
                width: 80.w,
                height: 80.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.r),
                  image: DecorationImage(
                    image: NetworkImage(freelancer.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              // Name, Verified, Rating
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            freelancer.name,
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2B2B2B),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Icon(Icons.verified, color: Colors.blue, size: 16.sp),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(Icons.star, color: AppColors.gold, size: 16.sp),
                        SizedBox(width: 4.w),
                        Text(
                          freelancer.rating.toString(),
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2B2B2B),
                          ),
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          AppStrings.freelancerProfileReviewsCount.tr(
                            namedArgs: {
                              'count': freelancer.reviewsCount.toString(),
                            },
                          ),
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Row 2: Job Title & Location
          Text(
            freelancer.title,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF2B2B2B),
            ),
          ),
          SizedBox(height: 8.h),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16.sp,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 4.w),
              Text(
                freelancer.location,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),

          // Row 3: Bio
          Text(
            freelancer.bio,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          SizedBox(height: 16.h),

          // Divider
          Divider(color: AppColors.grey200, height: 1.h),
          SizedBox(height: 16.h),

          // Row 4: Stats
          _buildStatsRow(),
        ],
      ),
    );
  }

  Widget _buildStatsRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _buildStatItem(
          freelancer.memberSince,
          AppStrings.freelancerProfileMemberSince.tr(),
        ),
        _buildVerticalDivider(),
        _buildStatItem(
          freelancer.responseTime,
          AppStrings.freelancerProfileResponse.tr(),
        ),
        _buildVerticalDivider(),
        _buildStatItem(
          freelancer.projectsCount.toString(),
          AppStrings.freelancerProfileProjects.tr(),
        ),
      ],
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2B2B2B),
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          label,
          style: TextStyle(fontSize: 10.sp, color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 30.h, width: 1.w, color: AppColors.grey200);
  }
}
