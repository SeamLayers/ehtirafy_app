import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import '../cubits/work_details_cubit.dart';
import '../cubits/work_details_state.dart';

class WorkDetailsScreen extends StatelessWidget {
  final String workId;

  const WorkDetailsScreen({super.key, required this.workId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      body: BlocBuilder<WorkDetailsCubit, WorkDetailsState>(
        builder: (context, state) {
          if (state is WorkDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.gold),
            );
          }

          if (state is WorkDetailsError) {
            return _buildErrorState(context, state.message);
          }

          if (state is WorkDetailsLoaded) {
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

  Widget _buildContent(BuildContext context, WorkDetailsLoaded state) {
    final work = state.workDetails;

    return CustomScrollView(
      slivers: [
        // Beautiful App Bar with image
        SliverAppBar(
          expandedHeight: 280.h,
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
                // Background Image or Gradient
                work.images.isNotEmpty
                    ? Image.network(
                        work.images.first,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _buildPlaceholderBg(),
                      )
                    : _buildPlaceholderBg(),
                // Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.7),
                      ],
                    ),
                  ),
                ),
                // Title at bottom
                Positioned(
                  bottom: 20.h,
                  left: 20.w,
                  right: 20.w,
                  child: Text(
                    work.title,
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
                // Date info card
                Container(
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
                  child: Row(
                    children: [
                      _buildInfoItem(
                        Icons.calendar_today_outlined,
                        'تاريخ الإنشاء',
                        work.createdAt,
                      ),
                      Container(
                        height: 40.h,
                        width: 1,
                        color: const Color(0xFFEEEEEE),
                      ),
                      _buildInfoItem(
                        Icons.update_outlined,
                        'آخر تحديث',
                        work.updatedAt,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                // Description section
                Text(
                  'الوصف',
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
                    work.description.isNotEmpty
                        ? work.description
                        : 'لا يوجد وصف متاح',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.textSecondary,
                      fontFamily: 'Cairo',
                      height: 1.8,
                    ),
                  ),
                ),

                SizedBox(height: 24.h),

                // Images gallery
                if (work.images.length > 1) ...[
                  Text(
                    'معرض الصور',
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: const Color(0xFF2B2B2B),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  SizedBox(
                    height: 120.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: work.images.length,
                      separatorBuilder: (_, __) => SizedBox(width: 12.w),
                      itemBuilder: (context, index) {
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(12.r),
                          child: Image.network(
                            work.images[index],
                            width: 150.w,
                            height: 120.h,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 150.w,
                              height: 120.h,
                              color: AppColors.grey200,
                              child: Icon(
                                Icons.image_outlined,
                                color: AppColors.textSecondary,
                                size: 32.sp,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],

                SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderBg() {
    return Container(
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
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 64.sp,
          color: Colors.white.withValues(alpha: 0.5),
        ),
      ),
    );
  }

  Widget _buildInfoItem(IconData icon, String label, String value) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(8.w),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.gold, size: 18.sp),
          ),
          SizedBox(width: 10.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 11.sp,
                  color: AppColors.textSecondary,
                  fontFamily: 'Cairo',
                ),
              ),
              Text(
                value.isNotEmpty ? value : '-',
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                  color: const Color(0xFF2B2B2B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
