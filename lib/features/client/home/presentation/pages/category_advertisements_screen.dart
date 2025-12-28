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
                          child: _PhotographerCard(
                            photographer: photographer,
                            index: index - 1,
                          ),
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
  final int index;

  const _PhotographerCard({required this.photographer, required this.index});

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.0, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutCubic,
      builder: (context, value, child) {
        return Transform.translate(
          offset: Offset(0, 50 * (1 - value)),
          child: Opacity(opacity: value, child: child),
        );
      },
      child: GestureDetector(
        onTap: () {
          // Use the ID directly in the path for path parameters
          context.push(
            '/advertisement/${photographer.id}',
            extra: {
              'freelancerId': photographer.freelancerId,
              'freelancerName': photographer.name,
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.r),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04), // Reduced shadow
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Section: Image/Placeholder & Basic Info
              Padding(
                padding: EdgeInsets.all(16.w),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile/Service Image
                    _buildServiceImage(),
                    SizedBox(width: 16.w),

                    // Title & Category
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            photographer
                                .category, // Using category as the main title
                            style: TextStyle(
                              color: const Color(0xFF1A1A1A),
                              fontSize: 16.sp,
                              fontFamily: 'Cairo',
                              fontWeight: FontWeight.w700,
                              height: 1.3,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 6.h),

                          // Rating Badge (if valid)
                          if (photographer.rating > 0)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: 8.w,
                                vertical: 4.h,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFFF9E6), // Light yellow
                                borderRadius: BorderRadius.circular(8.r),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    Icons.star_rounded,
                                    color: const Color(0xFFFFB800),
                                    size: 16.sp,
                                  ),
                                  SizedBox(width: 4.w),
                                  Text(
                                    photographer.rating.toStringAsFixed(1),
                                    style: TextStyle(
                                      color: const Color(0xFFB38200),
                                      fontSize: 12.sp,
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            Text(
                              'خدمة مميزة',
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
              ),

              // Middle Divider
              Divider(height: 1, color: Colors.grey.withValues(alpha: 0.1)),

              // Bottom Section: Details & Price
              Padding(
                padding: EdgeInsets.fromLTRB(16.w, 12.w, 16.w, 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Availability Chips (if any)
                    if (photographer.daysAvailability.isNotEmpty) ...[
                      SizedBox(
                        height: 28.h,
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          itemCount: photographer.daysAvailability.length,
                          separatorBuilder: (_, __) => SizedBox(width: 8.w),
                          itemBuilder: (context, index) {
                            return Container(
                              padding: EdgeInsets.symmetric(horizontal: 10.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5F5F5),
                                borderRadius: BorderRadius.circular(20.r),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                photographer.daysAvailability[index],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 11.sp,
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 16.h),
                    ],

                    // Price & Action Button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        // Price
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'سعر الخدمة',
                              style: TextStyle(
                                color: Colors.grey[500],
                                fontSize: 11.sp,
                                fontFamily: 'Cairo',
                              ),
                            ),
                            SizedBox(height: 2.h),
                            RichText(
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text: '${photographer.price}',
                                    style: TextStyle(
                                      color: const Color(0xFF1A1A1A),
                                      fontSize: 20.sp,
                                      fontFamily: 'Cairo',
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  TextSpan(
                                    text: ' ر.س',
                                    style: TextStyle(
                                      color: Colors.grey[600],
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

                        // Action Button
                        Container(
                          width: 44.w,
                          height: 44.w,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFF1A1A1A,
                            ), // Dark elegant button
                            borderRadius: BorderRadius.circular(14.r),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                blurRadius: 10,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Icon(
                            Icons.arrow_forward_rounded,
                            color: Colors.white,
                            size: 20.sp,
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
      ),
    );
  }

  Widget _buildServiceImage() {
    return Container(
      width: 70.w,
      height: 70.w,
      decoration: BoxDecoration(
        color: const Color(0xFFF9F9F9),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
      ),
      child: photographer.imageUrl.isNotEmpty
          ? ClipRRect(
              borderRadius: BorderRadius.circular(16.r),
              child: Image.network(
                photographer.imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => _buildPlaceholderIcon(),
              ),
            )
          : _buildPlaceholderIcon(),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Center(
      child: Icon(
        Icons.camera_alt_outlined,
        color: Colors.grey[400],
        size: 28.sp,
      ),
    );
  }
}
