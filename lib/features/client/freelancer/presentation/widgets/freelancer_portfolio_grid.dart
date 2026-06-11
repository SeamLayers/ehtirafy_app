import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/freelancer_entity.dart';
import 'package:go_router/go_router.dart';

class FreelancerPortfolioGrid extends StatelessWidget {
  final List<PortfolioItemEntity> portfolio;

  const FreelancerPortfolioGrid({super.key, required this.portfolio});

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.zero,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 14.w,
        mainAxisSpacing: 14.h,
        childAspectRatio: 1.0,
      ),
      itemCount: portfolio.length,
      itemBuilder: (context, index) {
        final item = portfolio[index];
        final imageUrl = item.imageUrl;
        return GestureDetector(
          onTap: () {
            // Navigate to work details
            context.push('/work/${item.id}');
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: AppColors.grey200,
                width: 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.08),
                  blurRadius: 14,
                  offset: Offset(0, 6.h),
                ),
                BoxShadow(
                  color: AppColors.shadowLight,
                  blurRadius: 8,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(18.r),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppCachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 512,
                    memCacheHeight: 512,
                  ),
                  // Smooth dark scrim for legible text over imagery.
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppColors.dark.withValues(alpha: 0.15),
                          AppColors.dark.withValues(alpha: 0.78),
                        ],
                        stops: const [0.45, 0.7, 1.0],
                      ),
                    ),
                  ),
                  // Subtle gold ring inside the card for a premium edge.
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(18.r),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.18),
                        width: 1,
                      ),
                    ),
                  ),
                  // Category badge (top), only when real portfolio data exists.
                  if (item.category.isNotEmpty)
                    PositionedDirectional(
                      top: 8.h,
                      start: 8.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.dark.withValues(alpha: 0.55),
                          borderRadius: BorderRadius.circular(8.r),
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.45),
                            width: 1,
                          ),
                        ),
                        child: Text(
                          item.category,
                          style: TextStyle(
                            color: AppColors.gold,
                            fontFamily: 'Cairo',
                            fontSize: 10.sp,
                            fontWeight: FontWeight.w700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  // Title row (bottom) with a small gold accent marker.
                  PositionedDirectional(
                    bottom: 12.h,
                    start: 12.w,
                    end: 12.w,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          width: 4.w,
                          height: 14.h,
                          decoration: BoxDecoration(
                            color: AppColors.gold,
                            borderRadius: BorderRadius.circular(2.r),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            item.title,
                            style: TextStyle(
                              color: AppColors.textLight,
                              fontFamily: 'Cairo',
                              fontSize: 12.sp,
                              fontWeight: FontWeight.w700,
                              height: 1.2,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
