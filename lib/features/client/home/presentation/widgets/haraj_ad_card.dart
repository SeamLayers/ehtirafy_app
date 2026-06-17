import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';
import 'package:ehtirafy_app/core/widgets/user_avatar.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/photographer_entity.dart';

/// Haraj-style horizontal advertisement card: a square thumbnail on the
/// leading (image) side, with title, price, location/time and the advertiser
/// row on the content side. Tapping opens the advertisement details screen.
class HarajAdCard extends StatelessWidget {
  final PhotographerEntity ad;

  const HarajAdCard({super.key, required this.ad});

  // Haraj listing titles use a calm green — kept close to the reference app
  // while the rest of the card stays on the Malam gold/dark palette.
  static const Color _titleGreen = Color(0xFF1F7A5A);

  // Group thousands so a price like 12000 renders as "12,000".
  String _formatPrice(int price) {
    final digits = price.abs().toString();
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) buffer.write(',');
      buffer.write(digits[i]);
    }
    return '${price < 0 ? '-' : ''}$buffer';
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.push(
          '/advertisement/${ad.id}',
          extra: {
            'freelancerId': ad.freelancerId,
            'freelancerName': ad.name,
          },
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: AppColors.grey200),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 10,
              offset: Offset(0, 3),
            ),
          ],
        ),
        padding: EdgeInsets.all(10.w),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Content (lands on the right in RTL)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ad.category.isNotEmpty
                          ? ad.category
                          : AppStrings.homeFeedAdFallbackTitle.tr(),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: _titleGreen,
                        fontSize: 15.sp,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w700,
                        height: 1.35,
                      ),
                    ),
                    SizedBox(height: 6.h),
                    if (ad.price > 0)
                      Row(
                        children: [
                          Text(
                            _formatPrice(ad.price),
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontSize: 15.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            'ريال',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 13.sp,
                          color: AppColors.grey500,
                        ),
                        SizedBox(width: 3.w),
                        Text(
                          AppStrings.homeFeedNow.tr(),
                          style: TextStyle(
                            color: AppColors.grey600,
                            fontSize: 11.sp,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        if (ad.location.isNotEmpty) ...[
                          SizedBox(width: 10.w),
                          Icon(
                            Icons.location_on_outlined,
                            size: 13.sp,
                            color: AppColors.grey500,
                          ),
                          SizedBox(width: 3.w),
                          Flexible(
                            child: Text(
                              ad.location,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.grey600,
                                fontSize: 11.sp,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Row(
                      children: [
                        UserAvatar(name: ad.name, size: 24),
                        SizedBox(width: 6.w),
                        Expanded(
                          child: Text(
                            ad.name.isNotEmpty
                                ? ad.name
                                : AppStrings.homeFeedAdOwner.tr(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontSize: 12.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10.w),
              // Thumbnail (lands on the left in RTL)
              ClipRRect(
                borderRadius: BorderRadius.circular(12.r),
                child: SizedBox(
                  width: 104.w,
                  height: 104.w,
                  child: AppCachedNetworkImage(
                    imageUrl: ad.imageUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 320,
                    memCacheHeight: 320,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
