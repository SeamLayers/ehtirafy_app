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
    context.read<CategoryAdvertisementsCubit>().loadAdvertisements(
      categoryId: categoryId,
      categoryName: categoryName,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
            ),
          ),
          child: SafeArea(
            child: Column(
              children: [
                // Premium Header
                _buildPremiumHeader(context),

                // Content
                Expanded(
                  child:
                      BlocBuilder<
                        CategoryAdvertisementsCubit,
                        CategoryAdvertisementsState
                      >(
                        builder: (context, state) {
                          if (state is CategoryAdvertisementsLoading) {
                            return Center(
                              child: CircularProgressIndicator(
                                color: AppColors.gold,
                                strokeWidth: 2,
                              ),
                            );
                          }

                          if (state is CategoryAdvertisementsError) {
                            return _buildErrorState(context, state.message);
                          }

                          if (state is CategoryAdvertisementsEmpty) {
                            return _buildEmptyState(context);
                          }

                          if (state is CategoryAdvertisementsLoaded) {
                            return _buildServicesList(state.photographers);
                          }

                          return const SizedBox.shrink();
                        },
                      ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPremiumHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 30.h),
      child: Column(
        children: [
          // Top Row with back button
          Row(
            children: [
              GestureDetector(
                onTap: () => context.pop(),
                child: Container(
                  width: 44.w,
                  height: 44.w,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14.r),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.2),
                    ),
                  ),
                  child: Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Colors.white,
                    size: 18.sp,
                  ),
                ),
              ),
              const Spacer(),
              // Filter button
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.gold,
                      AppColors.gold.withValues(alpha: 0.8),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14.r),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  Icons.tune_rounded,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ],
          ),

          SizedBox(height: 30.h),

          // Category Title with decorative elements
          Stack(
            alignment: Alignment.center,
            children: [
              // Glow effect
              Container(
                width: 200.w,
                height: 60.h,
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    colors: [
                      AppColors.gold.withValues(alpha: 0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
              Column(
                children: [
                  Text(
                    categoryName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 16.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.gold.withValues(alpha: 0.2),
                          AppColors.gold.withValues(alpha: 0.1),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(20.r),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.3),
                      ),
                    ),
                    child: Text(
                      'اكتشف أفضل الخدمات المميزة',
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
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList(List<PhotographerEntity> photographers) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32.r)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: EdgeInsets.only(top: 12.h),
            width: 40.w,
            height: 4.h,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2.r),
            ),
          ),

          // Results header
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 10.h),
            child: Row(
              children: [
                Container(
                  padding: EdgeInsets.all(10.w),
                  decoration: BoxDecoration(
                    color: AppColors.gold.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  child: Icon(
                    Icons.camera_alt_rounded,
                    color: AppColors.gold,
                    size: 20.sp,
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الخدمات المتاحة',
                      style: TextStyle(
                        color: const Color(0xFF1A1A2E),
                        fontSize: 16.sp,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${photographers.length} خدمة متوفرة',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12.sp,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Services list
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
              itemCount: photographers.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: EdgeInsets.only(bottom: 16.h),
                  child: _PremiumServiceCard(
                    photographer: photographers[index],
                    index: index,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(24.w),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 48.sp,
              color: Colors.white.withValues(alpha: 0.5),
            ),
          ),
          SizedBox(height: 20.h),
          Text(
            'لا توجد خدمات متاحة',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            'جرب البحث في فئة أخرى',
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.6),
              fontSize: 14.sp,
              fontFamily: 'Cairo',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.error_outline_rounded,
            size: 48.sp,
            color: Colors.red[300],
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.8),
              fontSize: 14.sp,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 20.h),
          GestureDetector(
            onTap: () {
              context.read<CategoryAdvertisementsCubit>().loadAdvertisements(
                categoryId: categoryId,
                categoryName: categoryName,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.gold,
                    AppColors.gold.withValues(alpha: 0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Text(
                'إعادة المحاولة',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontFamily: 'Cairo',
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PremiumServiceCard extends StatelessWidget {
  final PhotographerEntity photographer;
  final int index;

  const _PremiumServiceCard({required this.photographer, required this.index});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
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
          borderRadius: BorderRadius.circular(24.r),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF1A1A2E).withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            // Image Section
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24.r),
                  ),
                  child: SizedBox(
                    height: 180.h,
                    width: double.infinity,
                    child: photographer.imageUrl.isNotEmpty
                        ? Image.network(
                            photographer.imageUrl,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) =>
                                _buildImagePlaceholder(),
                          )
                        : _buildImagePlaceholder(),
                  ),
                ),

                // Gradient overlay
                Positioned.fill(
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(24.r),
                      ),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.3),
                        ],
                      ),
                    ),
                  ),
                ),

                // Rating badge
                Positioned(
                  top: 12.h,
                  left: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 10.w,
                      vertical: 6.h,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.r),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.1),
                          blurRadius: 8,
                        ),
                      ],
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
                          photographer.rating > 0
                              ? photographer.rating.toStringAsFixed(1)
                              : 'جديد',
                          style: TextStyle(
                            color: const Color(0xFF1A1A2E),
                            fontSize: 12.sp,
                            fontFamily: 'Cairo',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Price badge
                Positioned(
                  bottom: 12.h,
                  right: 12.w,
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 14.w,
                      vertical: 8.h,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.gold,
                          AppColors.gold.withValues(alpha: 0.9),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.4),
                          blurRadius: 12,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      '${photographer.price.toInt()} ر.س',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),

            // Details Section
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photographer.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: const Color(0xFF1A1A2E),
                      fontSize: 18.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5F5F5),
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.person_outline_rounded,
                          color: Colors.grey[600],
                          size: 18.sp,
                        ),
                      ),
                      SizedBox(width: 10.w),
                      Expanded(
                        child: Text(
                          photographer.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.grey[700],
                            fontSize: 14.sp,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                      Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF1A1A2E), Color(0xFF16213E)],
                          ),
                          borderRadius: BorderRadius.circular(14.r),
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
    );
  }

  Widget _buildImagePlaceholder() {
    return Container(
      color: const Color(0xFFF5F5F5),
      child: Center(
        child: Icon(
          Icons.camera_alt_outlined,
          color: Colors.grey[400],
          size: 40.sp,
        ),
      ),
    );
  }
}
