import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/freelancer_entity.dart';

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
      itemCount: portfolio.length,
      itemBuilder: (context, index) {
        final item = portfolio[index];
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            image: DecorationImage(
              image: NetworkImage(item.imageUrl),
              fit: BoxFit.cover,
            ),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.7),
                ],
                stops: const [0.6, 1.0],
              ),
            ),
            alignment: Alignment.bottomRight,
            padding: EdgeInsets.all(12.w),
            child: Text(
              item.title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        );
      },
    );
  }
}
