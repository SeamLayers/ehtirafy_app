import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
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

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // Beautiful App Bar with gradient
            SliverAppBar(
              expandedHeight: 220.h,
              pinned: true,
              backgroundColor: const Color(0xFF2B2B2B),
              leading: GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  margin: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.black.withValues(alpha: 0.3),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.arrow_back_ios_new,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  fit: StackFit.expand,
                  children: [
                    // Background gradient with decorative elements
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.gold.withValues(alpha: 0.2),
                            const Color(0xFF2B2B2B),
                          ],
                        ),
                      ),
                    ),
                    // Decorative circles
                    Positioned(
                      top: -30.h,
                      right: -30.w,
                      child: Container(
                        width: 150.w,
                        height: 150.h,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.gold.withValues(alpha: 0.1),
                        ),
                      ),
                    ),
                    // Content
                    Positioned(
                      bottom: 20.h,
                      left: 20.w,
                      right: 20.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status badge
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 12.w,
                              vertical: 4.h,
                            ),
                            decoration: BoxDecoration(
                              color: _getStatusColor(ad.status),
                              borderRadius: BorderRadius.circular(20.r),
                            ),
                            child: Text(
                              _getStatusText(ad.status),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 11.sp,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          SizedBox(height: 12.h),
                          // Title
                          Text(
                            ad.title,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 8,
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

            // Content
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Price card
                    Container(
                      width: double.infinity,
                      padding: EdgeInsets.all(20.w),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            AppColors.gold,
                            AppColors.gold.withValues(alpha: 0.8),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.gold.withValues(alpha: 0.3),
                            blurRadius: 15,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'سعر الخدمة',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.8),
                                  fontSize: 13.sp,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                '${ad.price.toStringAsFixed(0)} ر.س',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: EdgeInsets.all(12.w),
                            decoration: BoxDecoration(
                              color: Colors.white.withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.attach_money_rounded,
                              color: Colors.white,
                              size: 28.sp,
                            ),
                          ),
                        ],
                      ),
                    ),

                    SizedBox(height: 24.h),

                    // Info cards row
                    Row(
                      children: [
                        Expanded(
                          child: _buildInfoCard(
                            Icons.visibility_outlined,
                            'المشاهدات',
                            '${ad.viewerCount}',
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: _buildInfoCard(
                            Icons.calendar_today_outlined,
                            'تاريخ الإنشاء',
                            ad.createdAt,
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 24.h),

                    // Days availability
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
                              vertical: 8.h,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.gold.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(20.r),
                              border: Border.all(
                                color: AppColors.gold.withValues(alpha: 0.3),
                              ),
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
                      padding: EdgeInsets.all(16.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16.r),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Text(
                        ad.description.isNotEmpty
                            ? ad.description
                            : 'لا يوجد وصف متاح',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                          fontFamily: 'Cairo',
                          height: 1.8,
                        ),
                      ),
                    ),

                    SizedBox(height: 100.h), // Space for bottom button
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
            padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 12.h),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.08),
                  blurRadius: 15,
                  offset: const Offset(0, -3),
                ),
              ],
            ),
            child: SafeArea(
              top: false,
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
                  padding: EdgeInsets.symmetric(vertical: 14.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      'احجز الآن',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoCard(IconData icon, String label, String value) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.gold, size: 20.sp),
          ),
          SizedBox(height: 10.h),
          Text(
            label,
            style: TextStyle(
              fontSize: 12.sp,
              color: AppColors.textSecondary,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            value,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cairo',
              color: const Color(0xFF2B2B2B),
            ),
          ),
        ],
      ),
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
