import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';

class HomeSpecialOfferBanner extends StatelessWidget {
  const HomeSpecialOfferBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push('/all-freelancers');
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 24.w),
        width: double.infinity,
        height: 198.h,
        padding: EdgeInsets.all(1.2.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22.r),
          gradient: const LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Color(0xFFC8A44F), Color(0xFF7A5EA8)],
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFC8A44F).withValues(alpha: 0.24),
              blurRadius: 26,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(21.r),
          child: Stack(
            fit: StackFit.expand,
            children: [
              const AppCachedNetworkImage(
                imageUrl: 'https://picsum.photos/seed/specialoffer/400/200',
                fit: BoxFit.cover,
                memCacheWidth: 800,
                memCacheHeight: 400,
              ),
              BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 1.5, sigmaY: 1.5),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        const Color(0xFF111111).withValues(alpha: 0.72),
                        const Color(0xFF111111).withValues(alpha: 0.40),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(
                top: -44.h,
                right: -20.w,
                child: Container(
                  width: 148.w,
                  height: 148.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.gold.withValues(alpha: 0.25),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(18.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10.w,
                              vertical: 5.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.12),
                              borderRadius: BorderRadius.circular(10.r),
                              border: Border.all(
                                color: Colors.white.withValues(alpha: 0.22),
                              ),
                            ),
                            child: Text(
                              'عرض خاص محدود',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                          SizedBox(height: 10.h),
                          Text(
                            'خصم 20%',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w900,
                              height: 1,
                            ),
                          ),
                          SizedBox(height: 5.h),
                          Text(
                            'على أول خدمة تصوير مع أفضل المصورين',
                            style: TextStyle(
                              color: const Color(0xE5FFFEFE),
                              fontSize: 13.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 14.w,
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'اطلب الآن',
                                  style: TextStyle(
                                    color: AppColors.gold,
                                    fontSize: 13.sp,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  color: AppColors.gold,
                                  size: 13.sp,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(width: 10.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 12.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.24),
                        ),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.local_fire_department_rounded,
                            color: AppColors.gold,
                            size: 20.sp,
                          ),
                          SizedBox(height: 4.h),
                          Text(
                            'لفترة',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
                            'محدودة',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
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
  }
}
