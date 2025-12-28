import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/photographer_entity.dart';
import 'package:ehtirafy_app/core/widgets/user_avatar.dart';

class HomeFeaturedPhotographers extends StatelessWidget {
  final List<PhotographerEntity> photographers;

  const HomeFeaturedPhotographers({super.key, required this.photographers});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'أبرز المصورين',
                style: TextStyle(
                  color: const Color(0xFF2B2B2B),
                  fontSize: 16.sp,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.w400,
                ),
              ),
              TextButton(
                onPressed: () => context.push('/all-freelancers'),
                child: Text(
                  'عرض الكل',
                  style: TextStyle(
                    color: AppColors.gold,
                    fontSize: 14.sp,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 16.h),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          itemCount: photographers.length,
          separatorBuilder: (context, index) => SizedBox(height: 16.h),
          itemBuilder: (context, index) {
            return _PhotographerCard(photographer: photographers[index]);
          },
        ),
      ],
    );
  }
}

class _PhotographerCard extends StatelessWidget {
  final PhotographerEntity photographer;

  const _PhotographerCard({required this.photographer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/freelancer/${photographer.id}'),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: const Color(0xFFE5E5E5)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x19000000),
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserAvatar(name: photographer.name, size: 80),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        photographer.name,
                        style: TextStyle(
                          color: const Color(0xFF2B2B2B),
                          fontSize: 16.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Icon(
                        Icons.bookmark_border,
                        color: AppColors.gold,
                        size: 24.w,
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    photographer.category,
                    style: TextStyle(
                      color: const Color(0xFF888888),
                      fontSize: 14.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(Icons.star, color: AppColors.gold, size: 16.w),
                      SizedBox(width: 4.w),
                      Text(
                        photographer.rating.toString(),
                        style: TextStyle(
                          color: const Color(0xFF2B2B2B),
                          fontSize: 14.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        '(${photographer.reviewsCount})',
                        style: TextStyle(
                          color: const Color(0xFF888888),
                          fontSize: 14.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      const Spacer(),
                      Icon(
                        Icons.location_on_outlined,
                        color: const Color(0xFF888888),
                        size: 16.w,
                      ),
                      SizedBox(width: 4.w),
                      Text(
                        photographer.location,
                        style: TextStyle(
                          color: const Color(0xFF888888),
                          fontSize: 14.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Text(
                          'عرض الملف',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          Text(
                            '${photographer.price}',
                            style: TextStyle(
                              color: AppColors.gold,
                              fontSize: 16.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'ريال',
                            style: TextStyle(
                              color: const Color(0xFF888888),
                              fontSize: 14.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
