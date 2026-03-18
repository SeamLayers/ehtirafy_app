import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/freelancer_entity.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/constants/demo_images.dart';

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
        crossAxisSpacing: 16.w,
        mainAxisSpacing: 16.h,
        childAspectRatio: 1.0,
      ),
      itemCount: DemoImages.items.length,
      itemBuilder: (context, index) {
        final imageUrl = DemoImages.items[index];
        final hasPortfolioItem = index < portfolio.length;
        final item = hasPortfolioItem ? portfolio[index] : null;
        return GestureDetector(
          onTap: () {
            // Navigate to work details
            if (hasPortfolioItem && item != null) {
              context.push('/work/${item.id}');
            }
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12.r),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  AppCachedNetworkImage(
                    imageUrl: imageUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 512,
                    memCacheHeight: 512,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.6),
                        ],
                        stops: const [0.6, 1.0],
                      ),
                    ),
                  ),
                  PositionedDirectional(
                    bottom: 10.h,
                    start: 10.w,
                    end: 10.w,
                    child: Text(
                      item?.title ?? 'عمل ${(index + 1)}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.bold,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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
