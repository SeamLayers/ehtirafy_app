import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/freelancer_entity.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/widgets/profile_info_card.dart';

class ProfileHeaderSection extends StatelessWidget {
  final FreelancerEntity freelancer;

  const ProfileHeaderSection({super.key, required this.freelancer});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 380.h, // Approx height to cover header + card overlap
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          // Layer 1: Background Header
          Container(
            height: 200.h,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF2B2B2B),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(24.r),
                bottomRight: Radius.circular(24.r),
              ),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://placehold.co/800x400/2B2B2B/FFFFFF/png?text=Wood+Texture',
                ),
                fit: BoxFit.cover,
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withValues(alpha: 0.5),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(24.r),
                  bottomRight: Radius.circular(24.r),
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 8.h),
                        child: Text(
                          AppStrings.freelancerProfileTitle.tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.share, color: Colors.white),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // Layer 2: The Floating Profile Card
          Positioned(
            top: 140.h,
            left: 24.w,
            right: 24.w,
            child: ProfileInfoCard(freelancer: freelancer),
          ),
        ],
      ),
    );
  }
}
