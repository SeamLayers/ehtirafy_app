import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/photographer_entity.dart';
import '../cubits/all_freelancers_cubit.dart';
import '../cubits/all_freelancers_state.dart';

class AllFreelancersScreen extends StatelessWidget {
  const AllFreelancersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: CustomScrollView(
        slivers: [
          // Beautiful App Bar
          SliverAppBar(
            expandedHeight: 160.h,
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
                  // Gradient background
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.gold.withValues(alpha: 0.3),
                          const Color(0xFF2B2B2B),
                        ],
                      ),
                    ),
                  ),
                  // Decorative elements
                  Positioned(
                    top: -50.h,
                    right: -50.w,
                    child: Container(
                      width: 180.w,
                      height: 180.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.gold.withValues(alpha: 0.1),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: -30.h,
                    left: -30.w,
                    child: Container(
                      width: 100.w,
                      height: 100.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withValues(alpha: 0.05),
                      ),
                    ),
                  ),
                  // Title
                  Positioned(
                    bottom: 24.h,
                    left: 20.w,
                    right: 20.w,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(10.w),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt_rounded,
                            color: AppColors.gold,
                            size: 24.sp,
                          ),
                        ),
                        SizedBox(height: 12.h),
                        Text(
                          'أبرز المصورين',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 22.sp,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          'اختر من بين أفضل المصورين المحترفين',
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 13.sp,
                            fontFamily: 'Cairo',
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
          BlocBuilder<AllFreelancersCubit, AllFreelancersState>(
            builder: (context, state) {
              if (state is AllFreelancersLoading) {
                return const SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.gold),
                  ),
                );
              }

              if (state is AllFreelancersError) {
                return SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error_outline,
                          size: 64.sp,
                          color: Colors.red.shade300,
                        ),
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
                        Text(
                          state.message,
                          style: TextStyle(
                            fontSize: 14.sp,
                            color: AppColors.textSecondary,
                            fontFamily: 'Cairo',
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 24.h),
                        ElevatedButton(
                          onPressed: () => context
                              .read<AllFreelancersCubit>()
                              .loadAllFreelancers(),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.gold,
                            padding: EdgeInsets.symmetric(
                              horizontal: 32.w,
                              vertical: 12.h,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                            ),
                          ),
                          child: Text(
                            'إعادة المحاولة',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14.sp,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }

              if (state is AllFreelancersLoaded) {
                if (state.freelancers.isEmpty) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.people_outline,
                            size: 64.sp,
                            color: AppColors.textSecondary,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'لا يوجد مصورين',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                return SliverPadding(
                  padding: EdgeInsets.all(20.w),
                  sliver: SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 16.h),
                        child: _FreelancerCard(
                          freelancer: state.freelancers[index],
                        ),
                      );
                    }, childCount: state.freelancers.length),
                  ),
                );
              }

              return const SliverToBoxAdapter(child: SizedBox.shrink());
            },
          ),
        ],
      ),
    );
  }
}

class _FreelancerCard extends StatelessWidget {
  final PhotographerEntity freelancer;

  const _FreelancerCard({required this.freelancer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/freelancer/${freelancer.id}'),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          children: [
            // Header with gradient
            Container(
              height: 100.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.gold.withValues(alpha: 0.2),
                    const Color(0xFF2B2B2B).withValues(alpha: 0.8),
                  ],
                ),
              ),
              child: Stack(
                children: [
                  // Rating badge
                  Positioned(
                    top: 12.h,
                    right: 12.w,
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: 10.w,
                        vertical: 4.h,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.star_rounded,
                            color: AppColors.gold,
                            size: 14.sp,
                          ),
                          SizedBox(width: 4.w),
                          Text(
                            freelancer.rating.toString(),
                            style: TextStyle(
                              color: const Color(0xFF2B2B2B),
                              fontSize: 12.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Avatar
                  Positioned(
                    bottom: -35.h,
                    left: 20.w,
                    child: Container(
                      width: 70.w,
                      height: 70.w,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.r),
                        border: Border.all(color: Colors.white, width: 3),
                        color: AppColors.grey200,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(11.r),
                        child: freelancer.imageUrl.isNotEmpty
                            ? Image.network(
                                freelancer.imageUrl,
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Icon(
                                  Icons.person,
                                  color: AppColors.textSecondary,
                                  size: 32.sp,
                                ),
                              )
                            : Icon(
                                Icons.person,
                                color: AppColors.textSecondary,
                                size: 32.sp,
                              ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // Content
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 45.h, 20.w, 16.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    freelancer.name,
                                    style: TextStyle(
                                      color: const Color(0xFF2B2B2B),
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Cairo',
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                SizedBox(width: 6.w),
                                Icon(
                                  Icons.verified,
                                  color: Colors.blue,
                                  size: 16.sp,
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              freelancer.category,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13.sp,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Price badge
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${freelancer.price}',
                              style: TextStyle(
                                color: AppColors.gold,
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'ر.س',
                              style: TextStyle(
                                color: AppColors.gold,
                                fontSize: 12.sp,
                                fontFamily: 'Cairo',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  // Info row
                  Row(
                    children: [
                      _buildInfoChip(
                        Icons.location_on_outlined,
                        freelancer.location,
                      ),
                      SizedBox(width: 12.w),
                      _buildInfoChip(
                        Icons.star_outline,
                        '${freelancer.reviewsCount} تقييم',
                      ),
                    ],
                  ),
                  SizedBox(height: 16.h),
                  // Action button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () =>
                          context.push('/freelancer/${freelancer.id}'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.gold,
                        padding: EdgeInsets.symmetric(vertical: 12.h),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'عرض الملف الشخصي',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoChip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14.sp, color: AppColors.textSecondary),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 12.sp,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }
}
