import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/widgets/rtl_back_button.dart';
import 'package:ehtirafy_app/core/widgets/custom_empty_state.dart';
import 'package:ehtirafy_app/core/widgets/error_state_widget.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';
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
                            child: SizedBox(
                              width: 36.r,
                              height: 36.r,
                              child: const CircularProgressIndicator(
                                color: AppColors.gold,
                                strokeWidth: 2.5,
                              ),
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
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 22.h),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.dark,
            AppColors.dark.withValues(alpha: 0.94),
          ],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.28),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
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
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.30),
                  ),
                ),
                child: Icon(
                  Icons.tune_rounded,
                  color: AppColors.gold,
                  size: 20.sp,
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          Text(
            widget.categoryName,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white,
              fontSize: 22.sp,
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
              height: 1.25,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            'اكتشف أفضل الإعلانات المتاحة في هذه الفئة',
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.75),
              fontSize: 12.sp,
              fontFamily: 'Cairo',
              height: 1.4,
            ),
          ),
          SizedBox(height: 14.h),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 7.h),
            decoration: BoxDecoration(
              color: AppColors.gold.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(20.r),
              border: Border.all(
                color: AppColors.gold.withValues(alpha: 0.35),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  color: AppColors.gold,
                  size: 14.sp,
                ),
                SizedBox(width: 6.w),
                Text(
                  'إعلانات مختارة بعناية',
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
    );
  }

  Widget _buildServicesList(List<PhotographerEntity> photographers) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(20.w, AppSpacing.md, 20.w, AppSpacing.sm),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(
                    color: AppColors.gold.withValues(alpha: 0.20),
                  ),
                ),
                child: Icon(
                  Icons.camera_alt_rounded,
                  color: AppColors.gold,
                  size: 20.sp,
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الإعلانات المتاحة',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16.sp,
                        fontFamily: 'Cairo',
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      '${photographers.length} إعلان متوفر',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12.sp,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.fromLTRB(20.w, AppSpacing.sm, 20.w, AppSpacing.lg),
            itemCount: photographers.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(bottom: AppSpacing.md),
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
    return const CustomEmptyState(
      title: 'لا توجد إعلانات متاحة',
      message: 'جرب البحث في فئة أخرى',
      icon: Icons.search_off_rounded,
      iconSize: 44,
    );
  }

  Widget _buildErrorState(BuildContext context, String message) {
    return ErrorStateWidget(
      message: message,
      retryText: 'إعادة المحاولة',
      onRetry: () {
        context.read<CategoryAdvertisementsCubit>().loadAdvertisements(
          categoryId: widget.categoryId,
          categoryName: widget.categoryName,
        );
      },
    );
  }
}

class _PremiumServiceCard extends StatelessWidget {
  final PhotographerEntity photographer;
  final int index;

  const _PremiumServiceCard({required this.photographer, required this.index});

  @override
  Widget build(BuildContext context) {
    final imageUrl = photographer.imageUrl;
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
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.06),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
            const BoxShadow(
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

                // Subtle gradient scrim for badge legibility
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20.r),
                    ),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            AppColors.dark.withValues(alpha: 0.18),
                          ],
                          stops: const [0.6, 1.0],
                        ),
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
                      border: Border.all(color: AppColors.grey200),
                      boxShadow: const [
                        BoxShadow(
                          color: AppColors.shadowLight,
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
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
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          AppColors.gold,
                          AppColors.gold.withValues(alpha: 0.82),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(14.r),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.gold.withValues(alpha: 0.32),
                          blurRadius: 10,
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
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.dark.withValues(alpha: 0.20),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        // Single auto-mirroring icon: renders pointing right
                        // in LTR and auto-mirrors to point left in RTL (the
                        // natural "open/forward" direction in Arabic).
                        child: Icon(
                          Icons.arrow_forward_rounded,
                          color: AppColors.gold,
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
