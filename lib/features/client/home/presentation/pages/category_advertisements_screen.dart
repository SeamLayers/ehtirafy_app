import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/rtl_back_button.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';
import 'package:ehtirafy_app/core/constants/demo_images.dart';
import 'package:ehtirafy_app/features/client/home/domain/entities/photographer_entity.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/category_advertisements_cubit.dart';
import 'package:ehtirafy_app/features/client/home/presentation/cubits/category_advertisements_state.dart';

class CategoryAdvertisementsScreen extends StatefulWidget {
  final String categoryId;
  final String categoryName;

  const CategoryAdvertisementsScreen({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  State<CategoryAdvertisementsScreen> createState() =>
      _CategoryAdvertisementsScreenState();
}

class _CategoryAdvertisementsScreenState extends State<CategoryAdvertisementsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoryAdvertisementsCubit>().loadAdvertisements(
        categoryId: widget.categoryId,
        categoryName: widget.categoryName,
      );
    });
  }

  @override
  void didUpdateWidget(covariant CategoryAdvertisementsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.categoryId != widget.categoryId ||
        oldWidget.categoryName != widget.categoryName) {
      context.read<CategoryAdvertisementsCubit>().loadAdvertisements(
        categoryId: widget.categoryId,
        categoryName: widget.categoryName,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: SafeArea(
          child: Column(
            children: [
              _buildHeader(context),
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
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
      decoration: BoxDecoration(
        color: AppColors.dark,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24.r),
          bottomRight: Radius.circular(24.r),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              RtlBackButton(color: Colors.white, size: 20.sp),
              const Spacer(),
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  color: Colors.white,
                  size: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Text(
            widget.categoryName,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'اكتشف أفضل الخدمات المتاحة في هذه الفئة',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 12.sp,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 14.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Text(
              'خدمات مختارة بعناية',
              style: TextStyle(
                color: AppColors.gold,
                fontSize: 12.sp,
                fontFamily: 'Cairo',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServicesList(List<PhotographerEntity> photographers) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 8.h),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.12),
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
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    '${photographers.length} خدمة متوفرة',
                    style: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12.sp,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
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
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: AppColors.grey100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.search_off_rounded,
              size: 44.sp,
              color: AppColors.grey400,
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            'لا توجد خدمات متاحة',
            style: TextStyle(
              color: AppColors.textPrimary,
              fontSize: 18.sp,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'جرب البحث في فئة أخرى',
            style: TextStyle(
              color: AppColors.textSecondary,
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
            size: 44.sp,
            color: AppColors.error.withValues(alpha: 0.8),
          ),
          SizedBox(height: 12.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              fontFamily: 'Cairo',
            ),
          ),
          SizedBox(height: 16.h),
          GestureDetector(
            onTap: () {
              context.read<CategoryAdvertisementsCubit>().loadAdvertisements(
                categoryId: widget.categoryId,
                categoryName: widget.categoryName,
              );
            },
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 12.h),
              decoration: BoxDecoration(
                color: AppColors.gold,
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
    final isRtl = Directionality.of(context) == ui.TextDirection.rtl;
    final imageUrl = DemoImages.items[index % DemoImages.items.length];
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
          borderRadius: BorderRadius.circular(20.r),
          border: Border.all(color: AppColors.grey200),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadowLight,
              blurRadius: 16,
              offset: Offset(0, 6),
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
                    top: Radius.circular(20.r),
                  ),
                  child: SizedBox(
                    height: 160.h,
                    width: double.infinity,
                    child: AppCachedNetworkImage(
                      imageUrl: imageUrl,
                      fit: BoxFit.cover,
                      memCacheWidth: 800,
                      memCacheHeight: 420,
                      errorWidget: _buildImagePlaceholder(),
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
                      border: Border.all(color: AppColors.grey200),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: AppColors.gold,
                          size: 16.sp,
                        ),
                        SizedBox(width: 4.w),
                        Text(
                          photographer.rating > 0
                              ? photographer.rating.toStringAsFixed(1)
                              : 'جديد',
                          style: TextStyle(
                            color: AppColors.textPrimary,
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
                      color: AppColors.gold,
                      borderRadius: BorderRadius.circular(14.r),
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
                      color: AppColors.textPrimary,
                      fontSize: 17.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(
                          color: AppColors.grey100,
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                        child: Icon(
                          Icons.person_outline_rounded,
                          color: AppColors.grey600,
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
                            color: AppColors.textSecondary,
                            fontSize: 14.sp,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                      Container(
                        width: 44.w,
                        height: 44.w,
                        decoration: BoxDecoration(
                          color: AppColors.dark,
                          borderRadius: BorderRadius.circular(14.r),
                        ),
                        child: Icon(
                          isRtl
                              ? Icons.arrow_back_rounded
                              : Icons.arrow_forward_rounded,
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
      color: AppColors.grey100,
      child: Center(
        child: Icon(
          Icons.camera_alt_outlined,
          color: AppColors.grey400,
          size: 40.sp,
        ),
      ),
    );
  }
}
