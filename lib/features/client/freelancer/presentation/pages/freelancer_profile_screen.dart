import 'dart:ui' as ui;

import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/features/shared/reviews/presentation/cubits/reviews_cubit.dart';
import 'package:ehtirafy_app/features/shared/reviews/presentation/cubits/reviews_state.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/session/auth_guard.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/cubits/freelancer_cubit.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/cubits/freelancer_state.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/widgets/freelancer_portfolio_grid.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/widgets/review_card.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/widgets/reviews_summary_widget.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/widgets/service_card.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/freelancer_entity.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';
import 'package:ehtirafy_app/core/widgets/custom_empty_state.dart';
import 'package:ehtirafy_app/core/widgets/error_state_widget.dart';
import 'package:ehtirafy_app/core/widgets/share/app_share_bottom_sheet.dart';

class FreelancerProfileScreen extends StatefulWidget {
  final String freelancerId;

  const FreelancerProfileScreen({super.key, required this.freelancerId});

  @override
  State<FreelancerProfileScreen> createState() =>
      _FreelancerProfileScreenState();
}

class _FreelancerProfileScreenState extends State<FreelancerProfileScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final ScrollController _scrollController = ScrollController();
  double _headerOpacity = 0.0;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final newOpacity = (_scrollController.offset / 150).clamp(0.0, 1.0);
    if ((newOpacity - _headerOpacity).abs() > 0.01) {
      setState(() => _headerOpacity = newOpacity);
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              sl<FreelancerCubit>()..getFreelancerProfile(widget.freelancerId),
        ),
        BlocProvider(
          create: (context) =>
              sl<ReviewsCubit>()..getUserRates(userId: widget.freelancerId),
        ),
      ],
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: BlocListener<FreelancerCubit, FreelancerState>(
          listener: (context, state) {
            if (state is FreelancerError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: AppColors.error,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            }
          },
          child: Scaffold(
            backgroundColor: AppColors.backgroundLight,
            body: BlocBuilder<FreelancerCubit, FreelancerState>(
              builder: (context, state) {
                if (state is FreelancerLoading) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.gold),
                  );
                } else if (state is FreelancerError) {
                  return ErrorStateWidget(
                    message: state.message,
                    onRetry: () {
                      context.read<FreelancerCubit>().getFreelancerProfile(
                        widget.freelancerId,
                      );
                    },
                  );
                } else if (state is FreelancerLoaded) {
                  return _buildProfileContent(context, state.freelancer);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfileContent(
    BuildContext context,
    FreelancerEntity freelancer,
  ) {
    return Stack(
      children: [
        CustomScrollView(
          controller: _scrollController,
          physics: const BouncingScrollPhysics(),
          slivers: [
            // Header
            SliverAppBar(
              pinned: true,
              expandedHeight: 220.h,
              backgroundColor: AppColors.dark,
              elevation: 0,
              scrolledUnderElevation: 0,
              leading: _buildBackButton(),
              title: AnimatedOpacity(
                opacity: _headerOpacity,
                duration: const Duration(milliseconds: 200),
                child: Text(
                  freelancer.name,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              centerTitle: true,
              actions: [
                GestureDetector(
                  onTap: () => AppShareBottomSheet.show(context),
                  child: Container(
                    margin: EdgeInsets.all(8.w),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.35),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.18),
                        width: 1,
                      ),
                    ),
                    padding: EdgeInsets.all(8.w),
                    child: Icon(
                      Icons.share_outlined,
                      color: Colors.white,
                      size: 18.sp,
                    ),
                  ),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                background: _buildHeaderBackground(freelancer),
              ),
            ),

            // Profile Card - NO overlap, just spacing
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 0),
                child: _buildEnhancedProfileCard(freelancer),
              ),
            ),

            // Tab Bar
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.only(top: 16.h),
                child: _buildTabBar(),
              ),
            ),

            // Tab Content
            SliverToBoxAdapter(
              child: SizedBox(
                height: MediaQuery.of(context).size.height * 0.55,
                child: TabBarView(
                  controller: _tabController,
                  physics: const BouncingScrollPhysics(),
                  children: [
                    _buildPortfolioTab(freelancer),
                    _buildServicesTab(freelancer),
                    _buildReviewsTab(freelancer),
                  ],
                ),
              ),
            ),

            // Bottom padding
            SliverToBoxAdapter(child: SizedBox(height: 100.h)),
          ],
        ),

        // Sticky Bottom Button
        Positioned(
          left: 0,
          right: 0,
          bottom: 0,
          child: _buildBottomButton(context),
        ),
      ],
    );
  }

  Widget _buildBackButton() {
    final isRtl = Directionality.of(context) == ui.TextDirection.rtl;
    return GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        margin: EdgeInsets.all(8.w),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.35),
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.18),
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
    );
  }

  Widget _buildHeaderBackground(FreelancerEntity freelancer) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        const AppCachedNetworkImage(
          imageUrl: 'https://picsum.photos/seed/profilebg/800/400',
          fit: BoxFit.cover,
          memCacheWidth: 1200,
          memCacheHeight: 600,
        ),
        // Gradient Overlay
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withValues(alpha: 0.2),
                Colors.black.withValues(alpha: 0.6),
              ],
            ),
          ),
        ),
        // Profile Info - positioned at bottom of header
        Positioned(
          bottom: 20.h,
          left: 20.w,
          right: 20.w,
          child: Row(
            children: [
              // Avatar with gold border
              Container(
                width: 64.w,
                height: 64.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: AppColors.gold, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12.r),
                  child: AppCachedNetworkImage(
                    imageUrl: freelancer.imageUrl,
                    fit: BoxFit.cover,
                    memCacheWidth: 256,
                    memCacheHeight: 256,
                    errorWidget: Icon(
                      Icons.person,
                      color: AppColors.textSecondary,
                      size: 32.sp,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 14.w),
              // Name and Title
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            freelancer.name,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Cairo',
                              shadows: [
                                Shadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 4,
                                ),
                              ],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Container(
                          padding: EdgeInsets.all(2.w),
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.verified,
                            color: Colors.blue,
                            size: 14.sp,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      freelancer.title,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 13.sp,
                        fontFamily: 'Cairo',
                        shadows: [
                          Shadow(
                            color: Colors.black.withValues(alpha: 0.5),
                            blurRadius: 4,
                          ),
                        ],
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              // Rating Badge
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.2),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
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
                      freelancer.rating.toString(),
                      style: TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 13.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildEnhancedProfileCard(FreelancerEntity freelancer) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: AppColors.grey200, width: 1),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.06),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatItem(
                Icons.star_rounded,
                AppColors.gold,
                freelancer.rating.toString(),
                '${freelancer.reviewsCount} ${AppStrings.freelancerProfileReviews.tr()}',
              ),
              _buildDivider(),
              _buildStatItem(
                Icons.work_outline_rounded,
                AppColors.info,
                freelancer.projectsCount.toString(),
                AppStrings.freelancerProfileProjects.tr(),
              ),
              _buildDivider(),
              _buildStatItem(
                Icons.access_time_rounded,
                AppColors.success,
                freelancer.responseTime,
                AppStrings.freelancerProfileResponse.tr(),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          const Divider(color: AppColors.grey200, height: 1),
          SizedBox(height: AppSpacing.md),
          Row(
            children: [
              Icon(
                Icons.location_on_outlined,
                size: 16.sp,
                color: AppColors.textSecondary,
              ),
              SizedBox(width: 4.w),
              Expanded(
                child: Text(
                  freelancer.location,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: AppColors.textSecondary,
                    fontFamily: 'Cairo',
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 4.h),
                decoration: BoxDecoration(
                  color: AppColors.gold.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20.r),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.calendar_today_outlined,
                      size: 12.sp,
                      color: AppColors.gold,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      '${AppStrings.freelancerProfileMemberSince.tr()} ${freelancer.memberSince}',
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: AppColors.gold,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: Text(
              freelancer.bio,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontSize: 13.sp,
                color: AppColors.textSecondary,
                height: 1.6,
                fontFamily: 'Cairo',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(
    IconData icon,
    Color color,
    String value,
    String label,
  ) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 20.sp),
        ),
        SizedBox(height: 8.h),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontFamily: 'Cairo',
          ),
        ),
        SizedBox(height: 2.h),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.sp,
            color: AppColors.textSecondary,
            fontFamily: 'Cairo',
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 50.h, width: 1, color: AppColors.grey200);
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200, width: 1),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.gold,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cairo',
        ),
        unselectedLabelStyle: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
          fontFamily: 'Cairo',
        ),
        indicatorColor: AppColors.gold,
        indicatorWeight: 3,
        indicatorSize: TabBarIndicatorSize.label,
        dividerColor: Colors.transparent,
        splashFactory: NoSplash.splashFactory,
        overlayColor: WidgetStateProperty.all(Colors.transparent),
        tabs: [
          Tab(text: AppStrings.freelancerProfilePortfolio.tr()),
          Tab(text: AppStrings.freelancerProfileServices.tr()),
          Tab(text: AppStrings.freelancerProfileReviews.tr()),
        ],
      ),
    );
  }

  Widget _buildPortfolioTab(FreelancerEntity freelancer) {
    if (freelancer.portfolio.isEmpty) {
      return Center(
        child: EmptyStateWidget(
          message: AppStrings.freelancerPortfolioEmptyTitle.tr(),
          subMessage: AppStrings.freelancerPortfolioEmptySubtitle.tr(),
          icon: Icons.photo_library_outlined,
        ),
      );
    }
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
      child: FreelancerPortfolioGrid(portfolio: freelancer.portfolio),
    );
  }

  Widget _buildServicesTab(FreelancerEntity freelancer) {
    final services = freelancer.services;

    if (services.isEmpty) {
      return Center(
        child: EmptyStateWidget(
          message: AppStrings.freelancerDashboardEmptyServices.tr(),
          icon: Icons.design_services_outlined,
        ),
      );
    }

    return ListView.builder(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
      itemCount: services.length,
      itemBuilder: (context, index) {
        final service = services[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: ServiceCard(
            id: service.id,
            title: service.title,
            price: service.price,
            description: service.description,
            imageUrl: service.imageUrl,
            onTap: () {
              context.push(
                '/advertisement/${service.id}',
                extra: {
                  'freelancerId': freelancer.id,
                  'freelancerName': freelancer.name,
                  'availableDays': service.daysAvailability,
                },
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab(FreelancerEntity freelancer) {
    return BlocBuilder<ReviewsCubit, ReviewsState>(
      builder: (context, state) {
        if (state is ReviewsLoading) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.gold),
          );
        } else if (state is ReviewsError) {
          return Center(
            child: Text(
              state.message,
              style: const TextStyle(color: AppColors.error),
            ),
          );
        } else if (state is ReviewsLoaded) {
          final reviews = state.reviews;

          // Calculate average rating and distribution
          double averageRating = 0;
          Map<int, double> distribution = {
            5: 0.0,
            4: 0.0,
            3: 0.0,
            2: 0.0,
            1: 0.0,
          };

          if (reviews.isNotEmpty) {
            double totalRating = 0;
            for (var review in reviews) {
              totalRating += review.rating;
              int roundedRating = review.rating.round().clamp(1, 5);
              distribution[roundedRating] =
                  (distribution[roundedRating] ?? 0) + 1;
            }
            averageRating = totalRating / reviews.length;

            // Convert counts to percentages
            distribution.forEach((key, value) {
              distribution[key] = value / reviews.length;
            });
          }

          return SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 80.h),
            child: Column(
              children: [
                ReviewsSummaryWidget(
                  rating: averageRating,
                  reviewsCount: reviews.length,
                  ratingDistribution: distribution,
                ),
                SizedBox(height: 20.h),
                if (reviews.isEmpty)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
                    child: Center(
                      child: Text(
                        AppStrings.noDataFound.tr(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 14.sp,
                          fontFamily: 'Cairo',
                        ),
                      ),
                    ),
                  ),
                ...reviews.map(
                  (review) => Padding(
                    padding: EdgeInsets.only(bottom: 12.h),
                    child: ReviewCard(
                      userName: review.userName,
                      userImage: review.userImage ?? '',
                      rating: review.rating,
                      date: review.date,
                      comment: review.comment,
                    ),
                  ),
                ),
                SizedBox(height: 20.h),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Reviewing is account-based: require login for guests.
                      if (!AuthGuard.ensureAuth(context)) return;
                      _showAddReviewDialog(context, freelancer.id);
                    },
                    icon: Icon(
                      Icons.rate_review_outlined,
                      color: AppColors.primary,
                      size: 18.sp,
                    ),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary, width: 1.4),
                      backgroundColor: AppColors.gold.withValues(alpha: 0.06),
                      padding: EdgeInsets.symmetric(vertical: 12.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    label: Text(
                      'أضف تقييم', // localized ideally
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  void _showAddReviewDialog(BuildContext context, String freelancerId) {
    final commentController = TextEditingController();
    double currentRating = 0;

    showDialog(
      context: context,
      builder: (dialogContext) => BlocProvider.value(
        value: context.read<ReviewsCubit>(),
        child: StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              title: Text(
                'أضف تقييمك',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: AppColors.textPrimary,
                ),
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < currentRating
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: AppColors.gold,
                          size: 32.sp,
                        ),
                        onPressed: () {
                          setState(() {
                            currentRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  SizedBox(height: AppSpacing.md),
                  TextField(
                    controller: commentController,
                    style: TextStyle(fontFamily: 'Cairo', fontSize: 14.sp),
                    decoration: InputDecoration(
                      hintText: 'اكتب تعليقك هنا...',
                      hintStyle: TextStyle(
                        fontFamily: 'Cairo',
                        color: AppColors.textSecondary,
                        fontSize: 13.sp,
                      ),
                      filled: true,
                      fillColor: AppColors.backgroundLight,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: AppColors.grey200),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: const BorderSide(color: AppColors.gold),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                    ),
                    maxLines: 3,
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    AppStrings.cancel.tr(),
                    style: const TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                BlocConsumer<ReviewsCubit, ReviewsState>(
                  listener: (context, state) {
                    if (state is ReviewsActionSuccess) {
                      final reviewsCubit = context.read<ReviewsCubit>();
                      Navigator.pop(context);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                      reviewsCubit.getUserRates(userId: freelancerId);
                    } else if (state is ReviewsError) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                    }
                  },
                  builder: (context, state) {
                    if (state is ReviewsLoading) {
                      return const CircularProgressIndicator();
                    }
                    return TextButton(
                      onPressed: () {
                        if (currentRating > 0) {
                          context.read<ReviewsCubit>().addRate(
                            ratedUserId: freelancerId,
                            advertisementId:
                                '', // TODO: Get from user's past contracts with this freelancer
                            rating: currentRating,
                            comment: commentController.text,
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('الرجاء اختيار التقييم'),
                            ),
                          );
                        }
                      },
                      child: Text(
                        AppStrings.confirm.tr(),
                        style: const TextStyle(color: AppColors.primary),
                      ),
                    );
                  },
                ),
              ],
            );
          },
        ),
      ),
    ).then((_) {
      // Refresh freelancer profile after dialog closes if success?
      // Better to listen to ReviewsCubit in the main screen
      if (!context.mounted) return;
      context.read<FreelancerCubit>().getFreelancerProfile(freelancerId);
    });
  }

  Widget _buildBottomButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 8.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20.r),
          topRight: Radius.circular(20.r),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.10),
            blurRadius: 18,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BlocBuilder<FreelancerCubit, FreelancerState>(
          builder: (context, state) {
            return Container(
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFFD4B466), AppColors.gold],
                ),
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.gold.withValues(alpha: 0.30),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: ElevatedButton(
                onPressed: () {
                // Booking is account-based: require login for guests.
                if (!AuthGuard.ensureAuth(context)) return;
                if (state is FreelancerLoaded) {
                  final services = state.freelancer.services;
                  if (services.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('لا توجد خدمات متاحة للحجز'),
                      ),
                    );
                    return;
                  }
                  if (services.length == 1) {
                    // Only one service, navigate directly
                    final service = services.first;
                    context.push(
                      '/booking/request',
                      extra: {
                        'advertisementId': service.id,
                        'photographerId': state.freelancer.id,
                        'photographerName': state.freelancer.name,
                        'serviceName': service.title,
                        'price': service.price,
                      },
                    );
                  } else {
                    // Multiple services, show selection bottom sheet
                    _showServiceSelectionSheet(context, state.freelancer);
                  }
                }
              },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.transparent,
                  shadowColor: Colors.transparent,
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
                      size: 16.sp,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      AppStrings.freelancerProfileOrderNow.tr(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  void _showServiceSelectionSheet(
    BuildContext context,
    FreelancerEntity freelancer,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (bottomSheetContext) => Container(
        padding: EdgeInsets.all(24.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Container(
                width: 44.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.grey300,
                  borderRadius: BorderRadius.circular(4.r),
                ),
              ),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              'اختر الخدمة',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: AppSpacing.md),
            ...freelancer.services.map(
              (service) => GestureDetector(
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  context.push(
                    '/booking/request',
                    extra: {
                      'advertisementId': service.id,
                      'photographerId': freelancer.id,
                      'photographerName': freelancer.name,
                      'serviceName': service.title,
                      'price': service.price,
                    },
                  );
                },
                child: Container(
                  margin: EdgeInsets.only(bottom: 12.h),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundLight,
                    borderRadius: BorderRadius.circular(16.r),
                    border: Border.all(color: AppColors.grey200),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              service.title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
                                color: AppColors.textPrimary,
                              ),
                            ),
                            if (service.description.isNotEmpty) ...[
                              SizedBox(height: 4.h),
                              Text(
                                service.description,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: AppColors.textSecondary,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      SizedBox(width: AppSpacing.sm),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.gold.withValues(alpha: 0.10),
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        child: Text(
                          '${service.price} ر.س',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: AppColors.gold,
                            fontFamily: 'Cairo',
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 8.h),
          ],
        ),
      ),
    );
  }
}
