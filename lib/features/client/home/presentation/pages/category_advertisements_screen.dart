import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/photographer_entity.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/category_advertisements_cubit.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/category_advertisements_state.dart';

class CategoryAdvertisementsScreen extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const CategoryAdvertisementsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    // Trigger data load when screen is built
    context.read<CategoryAdvertisementsCubit>().loadAdvertisements(
      categoryId: categoryId,
      categoryName: categoryName,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        body: CustomScrollView(
          slivers: [
            // Elegant App Bar with gradient
            SliverAppBar(
              expandedHeight: 200.h,
              floating: false,
              pinned: true,
              elevation: 0,
              backgroundColor: Colors.white,
              leading: IconButton(
                icon: Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.08),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios,
                    color: AppColors.primary,
                    size: 18.sp,
                  ),
                ),
                onPressed: () => context.pop(),
              ),
              flexibleSpace: FlexibleSpaceBar(
                centerTitle: true,
                titlePadding: EdgeInsets.only(bottom: 16.h),
                title: Text(
                  categoryName,
                  style: TextStyle(
                    color: AppColors.primary,
                    fontSize: 16.sp,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w700,
                  ),
                ),
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.gold.withValues(alpha: 0.2),
                        AppColors.gold.withValues(alpha: 0.05),
                        Colors.white,
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                  child: Stack(
                    children: [
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
                      Positioned(
                        bottom: 40.h,
                        left: -40.w,
                        child: Container(
                          width: 100.w,
                          height: 100.h,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: AppColors.gold.withValues(alpha: 0.08),
                          ),
                        ),
                      ),
                      // Main content
                      SafeArea(
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 16.h),
                              // Category emoji with animated-like container
                              Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Outer glow ring
                                  Container(
                                    width: 100.w,
                                    height: 100.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      gradient: RadialGradient(
                                        colors: [
                                          AppColors.gold.withValues(alpha: 0.2),
                                          AppColors.gold.withValues(alpha: 0.0),
                                        ],
                                      ),
                                    ),
                                  ),
                                  // Middle ring
                                  Container(
                                    width: 80.w,
                                    height: 80.h,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: AppColors.gold.withValues(
                                          alpha: 0.3,
                                        ),
                                        width: 2,
                                      ),
                                    ),
                                  ),
                                  // Emoji container
                                  Container(
                                    padding: EdgeInsets.all(18.w),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: AppColors.gold.withValues(
                                            alpha: 0.25,
                                          ),
                                          blurRadius: 25,
                                          spreadRadius: 8,
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      _getCategoryEmoji(categoryName),
                                      style: TextStyle(fontSize: 36.sp),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12.h),
                              // Subtitle
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 6.h,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.gold.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20.r),
                                ),
                                child: Text(
                                  'استعرض أفضل المصورين',
                                  style: TextStyle(
                                    color: AppColors.gold,
                                    fontSize: 12.sp,
                                    fontFamily: 'Cairo',
                                    fontWeight: FontWeight.w500,
                                  ),
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
            ),

            // Content
            BlocBuilder<
              CategoryAdvertisementsCubit,
              CategoryAdvertisementsState
            >(
              builder: (context, state) {
                if (state is CategoryAdvertisementsLoading) {
                  return SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(
                            color: AppColors.gold,
                            strokeWidth: 3,
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            'جاري تحميل الخدمات...',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14.sp,
                              fontFamily: 'Cairo',
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }

                if (state is CategoryAdvertisementsError) {
                  return SliverFillRemaining(
                    child: _buildErrorState(context, state.message),
                  );
                }

                if (state is CategoryAdvertisementsEmpty) {
                  return SliverFillRemaining(child: _buildEmptyState(context));
                }

                if (state is CategoryAdvertisementsLoaded) {
                  return SliverPadding(
                    padding: EdgeInsets.all(16.w),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        if (index == 0) {
                          return Padding(
                            padding: EdgeInsets.only(bottom: 16.h),
                            child: _buildResultsHeader(
                              state.photographers.length,
                            ),
                          );
                        }
                        final photographer = state.photographers[index - 1];
                        return Padding(
                          padding: EdgeInsets.only(bottom: 16.h),
                          child: _PhotographerCard(photographer: photographer),
                        );
                      }, childCount: state.photographers.length + 1),
                    ),
                  );
                }

                return const SliverToBoxAdapter(child: SizedBox.shrink());
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildResultsHeader(int count) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFE5E5E5)),
      ),
      child: Row(
        children: [
          Icon(Icons.search, color: AppColors.gold, size: 20.sp),
          SizedBox(width: 8.w),
          Text(
            'تم العثور على $count خدمة',
            style: TextStyle(
              color: const Color(0xFF2B2B2B),
              fontSize: 14.sp,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.search_off_rounded,
                size: 64.sp,
                color: Colors.grey[400],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'لا توجد خدمات في هذه الفئة',
              style: TextStyle(
                color: const Color(0xFF2B2B2B),
                fontSize: 18.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'جرب البحث في فئات أخرى',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () => context.pop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('العودة للرئيسية'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: EdgeInsets.all(24.w),
              decoration: BoxDecoration(
                color: Colors.red[50],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.error_outline,
                size: 64.sp,
                color: Colors.red[400],
              ),
            ),
            SizedBox(height: 24.h),
            Text(
              'حدث خطأ',
              style: TextStyle(
                color: const Color(0xFF2B2B2B),
                fontSize: 18.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              message,
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24.h),
            ElevatedButton.icon(
              onPressed: () {
                context.read<CategoryAdvertisementsCubit>().loadAdvertisements(
                  categoryId: categoryId,
                  categoryName: categoryName,
                );
              },
              icon: const Icon(Icons.refresh),
              label: const Text('إعادة المحاولة'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.gold,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getCategoryEmoji(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('party') ||
        lower.contains('parties') ||
        lower.contains('حفل')) {
      return '🎉';
    } else if (lower.contains('wedding') || lower.contains('زفاف')) {
      return '💍';
    } else if (lower.contains('baby') || lower.contains('طفل')) {
      return '👶';
    } else if (lower.contains('photo') || lower.contains('تصوير')) {
      return '📸';
    } else if (lower.contains('video') || lower.contains('فيديو')) {
      return '🎬';
    } else if (lower.contains('product') || lower.contains('منتج')) {
      return '📦';
    }
    return '📷';
  }
}

class _PhotographerCard extends StatelessWidget {
  final PhotographerEntity photographer;

  const _PhotographerCard({required this.photographer});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.push('/freelancer/${photographer.id}'),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Image with gradient border
            Container(
              padding: EdgeInsets.all(3.w),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppColors.gold,
                    AppColors.gold.withValues(alpha: 0.5),
                  ],
                ),
              ),
              child: CircleAvatar(
                radius: 32.r,
                backgroundColor: Colors.grey[200],
                backgroundImage: photographer.imageUrl.isNotEmpty
                    ? NetworkImage(photographer.imageUrl)
                    : null,
                child: photographer.imageUrl.isEmpty
                    ? Icon(Icons.person, size: 32.sp, color: Colors.grey[400])
                    : null,
              ),
            ),
            SizedBox(width: 16.w),

            // Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Name and Rating Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          photographer.name,
                          style: TextStyle(
                            color: const Color(0xFF2B2B2B),
                            fontSize: 16.sp,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.w600,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8.w,
                          vertical: 4.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.star,
                              color: AppColors.gold,
                              size: 14.sp,
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              photographer.rating.toStringAsFixed(1),
                              style: TextStyle(
                                color: AppColors.gold,
                                fontSize: 12.sp,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),

                  // Category
                  Row(
                    children: [
                      Icon(
                        Icons.category_outlined,
                        size: 14.sp,
                        color: Colors.grey[500],
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          photographer.category,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13.sp,
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 4.h),

                  // Location
                  Row(
                    children: [
                      Icon(
                        Icons.location_on_outlined,
                        size: 14.sp,
                        color: Colors.grey[500],
                      ),
                      SizedBox(width: 4.w),
                      Expanded(
                        child: Text(
                          photographer.location,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 13.sp,
                            fontFamily: 'Cairo',
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),

                  // Price and View Button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Price
                      RichText(
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'ابتداءً من ',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12.sp,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            TextSpan(
                              text: '${photographer.price.toInt()} ر.س',
                              style: TextStyle(
                                color: AppColors.gold,
                                fontSize: 14.sp,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // View Button
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 16.w,
                          vertical: 8.h,
                        ),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.gold,
                              AppColors.gold.withValues(alpha: 0.8),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10.r),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.gold.withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'عرض الملف',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 12.sp,
                                fontFamily: 'Cairo',
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: 4.w),
                            Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.white,
                              size: 12.sp,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
