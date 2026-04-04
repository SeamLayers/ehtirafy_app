import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'package:ehtirafy_app/core/constants/demo_images.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/photographer_entity.dart';

class HomeFeaturedPhotographers extends StatelessWidget {
  final List<PhotographerEntity> photographers;

  const HomeFeaturedPhotographers({super.key, required this.photographers});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'أبرز المصورين',
                    style: TextStyle(
                      color: const Color(0xFF2B2B2B),
                      fontSize: 18.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    'اختيارات مميزة حسب التقييم والجودة',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: const Color(0xFF8D8D8D),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(999.r),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.28),
                  ),
                ),
                child: TextButton(
                  style: TextButton.styleFrom(
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 6.h,
                    ),
                  ),
                  onPressed: () => context.push('/all-freelancers'),
                  child: Text(
                    'عرض الكل',
                    style: TextStyle(
                      color: AppColors.gold,
                      fontSize: 12.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                    ),
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
            return _PhotographerCard(
              photographer: photographers[index],
              index: index,
            );
          },
        ),
      ],
    );
  }
}

class _PhotographerCard extends StatelessWidget {
  final PhotographerEntity photographer;
  final int index;

  const _PhotographerCard({required this.photographer, required this.index});

  @override
  Widget build(BuildContext context) {
    final imageUrl = photographer.imageUrl.isNotEmpty
        ? photographer.imageUrl
        : DemoImages.items[index % DemoImages.items.length];
    final theme = Theme.of(context);
    final availabilityLabel = photographer.daysAvailability.isNotEmpty
        ? 'متاح ${photographer.daysAvailability.length} أيام'
        : 'متاح للحجز';

    return GestureDetector(
      onTap: () => context.push('/freelancer/${photographer.id}'),
      child: Container(
        padding: EdgeInsets.all(1.3.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFC8A44F), Color(0xFFEAD39C), Color(0xFFF5EED5)],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.18),
              blurRadius: 24,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: Container(
          padding: EdgeInsets.all(12.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(21.r),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(14.r),
                child: Stack(
                  children: [
                    AppCachedNetworkImage(
                      imageUrl: imageUrl,
                      width: 94.w,
                      height: 106.h,
                      fit: BoxFit.cover,
                      memCacheWidth: 400,
                      memCacheHeight: 420,
                      errorWidget: Icon(
                        Icons.person_outline,
                        color: AppColors.grey500,
                        size: 30.sp,
                      ),
                    ),
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withValues(alpha: 0.38),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      top: 6.h,
                      left: 6.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 6.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFF0F8B8D,
                          ).withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.verified_rounded,
                              color: Colors.white,
                              size: 11.sp,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              'موثوق',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 9.sp,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 6.h,
                      right: 6.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 7.w,
                          vertical: 3.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black.withValues(alpha: 0.46),
                          borderRadius: BorderRadius.circular(999.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star_rounded,
                              color: const Color(0xFFFFC94A),
                              size: 12.sp,
                            ),
                            SizedBox(width: 3.w),
                            Text(
                              photographer.rating.toStringAsFixed(1),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 10.sp,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            photographer.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF2B2B2B),
                              fontSize: 17.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        Container(
                          width: 30.w,
                          height: 30.w,
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(9.r),
                          ),
                          child: Icon(
                            Icons.bookmark_border_rounded,
                            color: AppColors.gold,
                            size: 18.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 7.h),
                    Wrap(
                      spacing: 6.w,
                      runSpacing: 5.h,
                      children: [
                        _FreelancerMetaChip(
                          icon: Icons.camera_alt_outlined,
                          text: photographer.category,
                          color: AppColors.gold,
                        ),
                        _FreelancerMetaChip(
                          icon: Icons.calendar_today_rounded,
                          text: availabilityLabel,
                          color: const Color(0xFF0F8B8D),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.reviews_outlined,
                          color: AppColors.gold,
                          size: 15.sp,
                        ),
                        SizedBox(width: 4.w),
                        Expanded(
                          child: Text(
                            '${photographer.reviewsCount} تقييم',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: const Color(0xFF707070),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.location_on_outlined,
                          color: const Color(0xFF8C8C8C),
                          size: 15.sp,
                        ),
                        SizedBox(width: 3.w),
                        Flexible(
                          child: Text(
                            photographer.location,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: const Color(0xFF888888),
                              fontSize: 11.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (photographer.daysAvailability.isNotEmpty) ...[
                      SizedBox(height: 5.h),
                      Row(
                        children: [
                          Icon(
                            Icons.event_available_outlined,
                            color: const Color(0xFF7D7D7D),
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Expanded(
                            child: Text(
                              photographer.daysAvailability.take(2).join(' • '),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: const Color(0xFF888888),
                                fontSize: 11.sp,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                    SizedBox(height: 10.h),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        return Row(
                          children: [
                            Expanded(
                              child: Container(
                                height: 38.h,
                                padding: EdgeInsets.symmetric(horizontal: 10.w),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [
                                      Color(0xFFC8A44F),
                                      Color(0xFFB58E39),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(11.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.gold.withValues(
                                        alpha: 0.24,
                                      ),
                                      blurRadius: 12,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'عرض الملف',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 11.sp,
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 4.w),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.white,
                                      size: 11.sp,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(width: 8.w),
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                maxWidth: constraints.maxWidth * 0.42,
                              ),
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 10.w,
                                    vertical: 7.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.gold.withValues(
                                      alpha: 0.10,
                                    ),
                                    borderRadius: BorderRadius.circular(10.r),
                                    border: Border.all(
                                      color: AppColors.gold.withValues(
                                        alpha: 0.24,
                                      ),
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        '${photographer.price}',
                                        style: TextStyle(
                                          color: AppColors.gold,
                                          fontSize: 17.sp,
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.w900,
                                        ),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        'ريال',
                                        style: TextStyle(
                                          color: const Color(0xFF888888),
                                          fontSize: 11.sp,
                                          fontFamily: 'Cairo',
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FreelancerMetaChip extends StatelessWidget {
  final IconData icon;
  final String text;
  final Color color;

  const _FreelancerMetaChip({
    required this.icon,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(999.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12.sp, color: color),
          SizedBox(width: 4.w),
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 94.w),
            child: Text(
              text,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: color,
                fontSize: 10.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
