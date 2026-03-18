import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/demo_images.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';
import '../cubits/advertisement_details_cubit.dart';
import '../cubits/advertisement_details_state.dart';

class AdvertisementDetailsScreen extends StatelessWidget {
  final String advertisementId;
  final String? freelancerId;
  final String? freelancerName;

  const AdvertisementDetailsScreen({
    super.key,
    required this.advertisementId,
    this.freelancerId,
    this.freelancerName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: BlocBuilder<AdvertisementDetailsCubit, AdvertisementDetailsState>(
        builder: (context, state) {
          if (state is AdvertisementDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }

          if (state is AdvertisementDetailsError) {
            return _buildErrorState(context, state.message);
          }

          if (state is AdvertisementDetailsLoaded) {
            return _buildContent(context, state);
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64.sp, color: Colors.red.shade300),
          SizedBox(height: 16.h),
          Text(
            'حدث خطأ',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 8.h),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32.w),
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14.sp,
                color: AppColors.textSecondary,
                fontFamily: 'Cairo',
              ),
            ),
          ),
          SizedBox(height: 24.h),
          ElevatedButton(
            onPressed: () => context.pop(),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.gold,
              padding: EdgeInsets.symmetric(horizontal: 32.w, vertical: 12.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'العودة',
              style: TextStyle(
                color: Colors.white,
                fontSize: 14.sp,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(BuildContext context, AdvertisementDetailsLoaded state) {
    final ad = state.advertisementDetails;
    final isRtl = Directionality.of(context) == ui.TextDirection.rtl;
    final coverImage =
        DemoImages.items[ad.id.hashCode.abs() % DemoImages.items.length];

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // Beautiful App Bar with gradient
            SliverAppBar(
              expandedHeight: 300.h,
              pinned: true,
              backgroundColor: const Color(0xFF2B2B2B),
              leading: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  margin: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    isRtl ? Icons.arrow_forward_ios : Icons.arrow_back_ios,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background Image (Demo)
                    AppCachedNetworkImage(
                      imageUrl: coverImage,
                      fit: BoxFit.cover,
                      memCacheWidth: 1200,
                      memCacheHeight: 700,
                    ),

                    // Gradient Overlay
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withValues(alpha: 0.2),
                            Colors.black.withValues(alpha: 0.8),
                          ],
                          stops: const [0.0, 0.6, 1.0],
                        ),
                      ),
                    ),

                    // Content Overlay
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: EdgeInsets.all(20.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Badges Row
                            Row(
                              children: [
                                _buildGlassBadge(
                                  text: _getStatusText(ad.status),
                                  color: _getStatusColor(ad.status),
                                  isSolid: true,
                                ),
                                if (ad.categoryName.isNotEmpty) ...[
                                  SizedBox(width: 8.w),
                                  _buildGlassBadge(
                                    text: ad.categoryName,
                                    icon: Icons.category_outlined,
                                  ),
                                ],
                              ],
                            ),
                            SizedBox(height: 16.h),
                            // Title
                            Text(
                              ad.title,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                                height: 1.3,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withValues(alpha: 0.5),
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Body Content
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFF9F9F9),
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(30.r),
                  ),
                ),
                child: Column(
                  children: [
                    // Price Card with generous spacing
                    SizedBox(height: 32.h),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: _buildPremiumPriceCard(context, ad.price),
                    ),

                    SizedBox(height: 24.h),

                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Stats Row
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 16.h,
                              horizontal: 12.w,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.03),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildStatItem(
                                    icon: Icons.visibility_outlined,
                                    label: 'المشاهدات',
                                    value: '${ad.viewerCount}',
                                  ),
                                ),
                                Container(
                                  height: 30.h,
                                  width: 1,
                                  color: Colors.grey.withValues(alpha: 0.2),
                                ),
                                Expanded(
                                  child: _buildStatItem(
                                    icon: Icons.calendar_today_outlined,
                                    label: 'التاريخ',
                                    value: ad.createdAt,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          SizedBox(height: 24.h),

                          // Days Availability
                          if (ad.daysAvailability.isNotEmpty) ...[
                            Text(
                              'أيام التوفر',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                                color: const Color(0xFF2B2B2B),
                              ),
                            ),
                            SizedBox(height: 12.h),
                            Wrap(
                              spacing: 8.w,
                              runSpacing: 8.h,
                              children: ad.daysAvailability.map((day) {
                                return Container(
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 16.w,
                                    vertical: 10.h,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(12.r),
                                    border: Border.all(
                                      color: AppColors.gold.withValues(
                                        alpha: 0.2,
                                      ),
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.gold.withValues(
                                          alpha: 0.05,
                                        ),
                                        blurRadius: 4,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Text(
                                    _translateDay(day),
                                    style: TextStyle(
                                      color: AppColors.gold,
                                      fontSize: 13.sp,
                                      fontWeight: FontWeight.w600,
                                      fontFamily: 'Cairo',
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                            SizedBox(height: 24.h),
                          ],

                          // Description
                          Text(
                            'وصف الخدمة',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                              color: const Color(0xFF2B2B2B),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(20.w),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16.r),
                              border: Border.all(
                                color: Colors.grey.withValues(alpha: 0.1),
                              ),
                            ),
                            child: Text(
                              ad.description.isNotEmpty
                                  ? ad.description
                                  : 'لا يوجد وصف متاح',
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: const Color(0xFF555555),
                                fontFamily: 'Cairo',
                                height: 1.8,
                              ),
                            ),
                          ),

                          SizedBox(height: 120.h), // Space for bottom button
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),

        // Bottom booking button
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 32.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 20,
                  offset: const Offset(0, -5),
                ),
              ],
            ),
            child: ElevatedButton(
              onPressed: () {
                // Navigate to booking
                if (freelancerId != null) {
                  context.push(
                    '/booking/request',
                    extra: {
                      'advertisementId': advertisementId,
                      'photographerId': freelancerId,
                      'photographerName': freelancerName ?? '',
                      'serviceName': ad.title,
                      'price': ad.price,
                      'availableDays': ad.daysAvailability,
                    },
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('لا يمكن الحجز حالياً')),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                padding: EdgeInsets.symmetric(vertical: 16.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
                elevation: 4,
                shadowColor: AppColors.gold.withValues(alpha: 0.4),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'احجز الآن',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Icon(
                    Icons.arrow_forward_rounded,
                    color: Colors.white,
                    size: 20.sp,
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGlassBadge({
    required String text,
    Color? color,
    IconData? icon,
    bool isSolid = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: isSolid ? color : Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(30.r),
        border: isSolid
            ? null
            : Border.all(color: Colors.white.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 14.sp),
            SizedBox(width: 6.w),
          ],
          Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 12.sp,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumPriceCard(BuildContext context, double price) {
    final isRtl = Directionality.of(context) == ui.TextDirection.rtl;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFD4AF37), Color(0xFFC5A028)],
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD4AF37).withValues(alpha: 0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),

      child: Stack(
        children: [
          // Background Decoration
          Positioned(
            right: -20,
            top: -20,
            child: Icon(
              Icons.monetization_on,
              size: 100.sp,
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'سعر الخدمة',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.9),
                      fontSize: 13.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: [
                      Text(
                        price.toStringAsFixed(0),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 32.sp,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Cairo',
                          height: 1,
                        ),
                      ),
                      SizedBox(width: 6.w),
                      Text(
                        'ر.س',
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.9),
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.3),
                  ),
                ),
                child: Icon(
                  isRtl ? Icons.arrow_back : Icons.arrow_forward,
                  color: Colors.white,
                  size: 24.sp,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem({
    required IconData icon,
    required String label,
    required String value,
    Color? iconColor,
  }) {
    return Column(
      children: [
        Icon(icon, color: iconColor ?? AppColors.textSecondary, size: 22.sp),
        SizedBox(height: 6.h),
        Text(
          label,
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: 11.sp,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          value,
          style: TextStyle(
            color: const Color(0xFF2B2B2B),
            fontSize: 13.sp,
            fontWeight: FontWeight.w700,
            fontFamily: 'Cairo',
          ),
        ),
      ],
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'published':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'rejected':
        return Colors.red;
      default:
        return AppColors.gold;
    }
  }

  String _getStatusText(String status) {
    switch (status.toLowerCase()) {
      case 'published':
        return 'منشور';
      case 'pending':
        return 'قيد المراجعة';
      case 'rejected':
        return 'مرفوض';
      default:
        return status;
    }
  }

  String _translateDay(String day) {
    switch (day.toLowerCase()) {
      case 'saturday':
        return 'السبت';
      case 'sunday':
        return 'الأحد';
      case 'monday':
        return 'الإثنين';
      case 'tuesday':
        return 'الثلاثاء';
      case 'wednesday':
        return 'الأربعاء';
      case 'thursday':
        return 'الخميس';
      case 'friday':
        return 'الجمعة';
      default:
        return day;
    }
  }
}
