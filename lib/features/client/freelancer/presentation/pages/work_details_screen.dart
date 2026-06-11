import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';
import 'package:ehtirafy_app/core/widgets/error_state_widget.dart';
import '../cubits/work_details_cubit.dart';
import '../cubits/work_details_state.dart';

class WorkDetailsScreen extends StatelessWidget {
  final String workId;

  const WorkDetailsScreen({super.key, required this.workId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
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
    return SafeArea(
      child: ErrorStateWidget(
        message: message,
        retryText: 'العودة',
        onRetry: () => context.pop(),
      ),
    );
  }

  Widget _buildContent(BuildContext context, WorkDetailsLoaded state) {
    final theme = Theme.of(context);
    final work = state.workDetails;
    final isRtl = Directionality.of(context) == ui.TextDirection.rtl;
    final coverImage = work.images.isNotEmpty ? work.images.first : '';

    return CustomScrollView(
      slivers: [
        // Beautiful App Bar with image
        SliverAppBar(
          expandedHeight: 280.h,
          pinned: true,
          stretch: true,
          backgroundColor: AppColors.dark,
          elevation: 0,
          leading: Padding(
            padding: EdgeInsets.all(8.w),
            child: GestureDetector(
              onTap: () => context.pop(),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withValues(alpha: 0.35),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.15),
                    width: 1,
                  ),
                ),
                child: Icon(
                  isRtl
                      ? Icons.arrow_forward_ios_rounded
                      : Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 18.sp,
                ),
              ),
            ),
          ),
          flexibleSpace: FlexibleSpaceBar(
            stretchModes: const [StretchMode.zoomBackground],
            background: Stack(
              fit: StackFit.expand,
              children: [
                // Background Image (real cover from API)
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
                        AppColors.dark.withValues(alpha: 0.25),
                        AppColors.dark.withValues(alpha: 0.85),
                      ],
                      stops: const [0.0, 0.55, 1.0],
                    ),
                  ),
                ),
                // Title at bottom
                Positioned(
                  bottom: AppSpacing.lg,
                  left: 20.w,
                  right: 20.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 36.w,
                        height: 4.h,
                        decoration: BoxDecoration(
                          color: AppColors.gold,
                          borderRadius: BorderRadius.circular(4.r),
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      Text(
                        work.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleLarge?.copyWith(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              height: 1.3,
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 8,
                                ),
                              ],
                            ) ??
                            TextStyle(
                              color: Colors.white,
                              fontSize: 22.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                              height: 1.3,
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
                // Date info card
                _buildSurfaceCard(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 18.h,
                  ),
                  child: Row(
                    children: [
                      _buildInfoItem(
                        context,
                        Icons.calendar_today_outlined,
                        'تاريخ الإنشاء',
                        work.createdAt,
                      ),
                      Container(
                        height: 44.h,
                        width: 1,
                        color: AppColors.grey200,
                      ),
                      _buildInfoItem(
                        context,
                        Icons.update_outlined,
                        'آخر تحديث',
                        work.updatedAt,
                      ),
                    ],
                  ),
                ),

                SizedBox(height: AppSpacing.lg),

                // Description section
                _buildSectionTitle(context, Icons.notes_rounded, 'الوصف'),
                SizedBox(height: AppSpacing.sm + 4.h),
                _buildSurfaceCard(
                  width: double.infinity,
                  padding: EdgeInsets.all(16.w),
                  child: Text(
                    work.description.isNotEmpty
                        ? work.description
                        : 'لا يوجد وصف متاح',
                    style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                          height: 1.8,
                        ) ??
                        TextStyle(
                          fontSize: 14.sp,
                          color: AppColors.textSecondary,
                          fontFamily: 'Cairo',
                          height: 1.8,
                        ),
                  ),
                ),

                // Images gallery
                if (work.images.length > 1) ...[
                  SizedBox(height: AppSpacing.lg),
                  _buildSectionTitle(
                    context,
                    Icons.photo_library_outlined,
                    'معرض الصور',
                  ),
                  SizedBox(height: AppSpacing.sm + 4.h),
                  SizedBox(
                    height: 120.h,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: EdgeInsets.zero,
                      itemCount: work.images.length,
                      separatorBuilder: (_, __) =>
                          SizedBox(width: AppSpacing.sm + 4.w),
                      itemBuilder: (context, index) {
                        return Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(14.r),
                            boxShadow: const [
                              BoxShadow(
                                color: AppColors.shadowLight,
                                blurRadius: 8,
                                offset: Offset(0, 3),
                              ),
                            ],
                          ),
                          child: AppCachedNetworkImage(
                            imageUrl: work.images[index],
                            width: 150.w,
                            height: 120.h,
                            fit: BoxFit.cover,
                            memCacheWidth: 400,
                            memCacheHeight: 320,
                            borderRadius: BorderRadius.circular(14.r),
                            errorWidget: Icon(
                              Icons.image_outlined,
                              color: AppColors.textSecondary,
                              size: 32.sp,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],

                SizedBox(height: AppSpacing.xxl),
              ],
            ),
          ),
        ),
      ],
    );
  }

  /// Consistent white surface card with soft shadow and subtle border.
  Widget _buildSurfaceCard({
    required Widget child,
    required EdgeInsetsGeometry padding,
    double? width,
  }) {
    return Container(
      width: width,
      padding: padding,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.grey200, width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(
    BuildContext context,
    IconData icon,
    String title,
  ) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(7.w),
          decoration: BoxDecoration(
            color: AppColors.gold.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10.r),
          ),
          child: Icon(icon, color: AppColors.gold, size: 18.sp),
        ),
        SizedBox(width: AppSpacing.sm + 2.w),
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ) ??
              TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
                color: AppColors.textPrimary,
              ),
        ),
      ],
    );
  }

  Widget _buildInfoItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    final theme = Theme.of(context);
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(9.w),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: AppColors.gold, size: 18.sp),
          ),
          SizedBox(width: AppSpacing.sm + 2.w),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodySmall?.copyWith(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                      ) ??
                      TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.textSecondary,
                        fontFamily: 'Cairo',
                      ),
                ),
                SizedBox(height: 2.h),
                Text(
                  value.isNotEmpty ? value : '-',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ) ??
                      TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                        color: AppColors.textPrimary,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
