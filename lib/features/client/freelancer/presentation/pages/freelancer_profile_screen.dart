import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:ehtirafy_app/features/shared/reviews/presentation/cubits/reviews_cubit.dart';
import 'package:ehtirafy_app/features/shared/reviews/presentation/cubits/reviews_state.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/cubits/freelancer_cubit.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/cubits/freelancer_state.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/widgets/freelancer_portfolio_grid.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/widgets/review_card.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/widgets/reviews_summary_widget.dart';
import 'package:ehtirafy_app/features/client/freelancer/presentation/widgets/service_card.dart';
import 'package:ehtirafy_app/features/client/freelancer/domain/entities/freelancer_entity.dart';
import 'package:ehtirafy_app/core/widgets/empty_state_widget.dart';
import 'package:ehtirafy_app/core/widgets/error_state_widget.dart';

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
        BlocProvider(create: (context) => sl<ReviewsCubit>()),
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
            backgroundColor: const Color(0xFFFAFAFA),
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
              backgroundColor: const Color(0xFF2B2B2B),
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
                IconButton(
                  icon: const Icon(Icons.share_outlined, color: Colors.white),
                  onPressed: () {},
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
    return GestureDetector(
      onTap: () => context.pop(),
      child: Container(
        margin: EdgeInsets.all(8.w),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: const Icon(
          Icons.arrow_back_ios_new,
          color: Colors.white,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildHeaderBackground(FreelancerEntity freelancer) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background Image
        Image.network(
          'https://picsum.photos/seed/profilebg/800/400',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) =>
              Container(color: const Color(0xFF2B2B2B)),
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
                  child: Image.network(
                    freelancer.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      color: AppColors.grey200,
                      child: Icon(
                        Icons.person,
                        color: AppColors.textSecondary,
                        size: 32.sp,
                      ),
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
                        color: const Color(0xFF2B2B2B),
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
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
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
                const Color(0xFF17A2B8),
                freelancer.projectsCount.toString(),
                AppStrings.freelancerProfileProjects.tr(),
              ),
              _buildDivider(),
              _buildStatItem(
                Icons.access_time_rounded,
                const Color(0xFF28A745),
                freelancer.responseTime,
                AppStrings.freelancerProfileResponse.tr(),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Divider(color: const Color(0xFFF0F0F0), height: 1),
          SizedBox(height: 16.h),
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
          SizedBox(height: 12.h),
          Text(
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
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF2B2B2B),
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
    return Container(height: 50.h, width: 1, color: const Color(0xFFF0F0F0));
  }

  Widget _buildTabBar() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.gold,
        unselectedLabelColor: const Color(0xFF888888),
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
            onTap: () {
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
          ),
        );
      },
    );
  }

  Widget _buildReviewsTab(FreelancerEntity freelancer) {
    final reviews = freelancer.reviews;

    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 80.h),
      child: Column(
        children: [
          ReviewsSummaryWidget(
            rating: freelancer.rating,
            reviewsCount: freelancer.reviewsCount,
            ratingDistribution: const {
              5: 0.8,
              4: 0.15,
              3: 0.05,
              2: 0.0,
              1: 0.0,
            },
          ),
          SizedBox(height: 20.h),
          if (reviews.isEmpty)
            Center(
              child: Text(
                AppStrings.noDataFound.tr(),
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
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
            child: OutlinedButton(
              onPressed: () => _showAddReviewDialog(context, freelancer.id),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.primary),
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.r),
                ),
              ),
              child: Text(
                'أضف تقييم', // localized ideally
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
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
              title: const Text('أضف تقييمك'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        icon: Icon(
                          index < currentRating
                              ? Icons.star
                              : Icons.star_border,
                          color: AppColors.primary,
                          size: 30.sp,
                        ),
                        onPressed: () {
                          setState(() {
                            currentRating = index + 1;
                          });
                        },
                      );
                    }),
                  ),
                  SizedBox(height: 16.h),
                  TextField(
                    controller: commentController,
                    decoration: InputDecoration(
                      hintText: 'اكتب تعليقك هنا...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.r),
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
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                ),
                BlocConsumer<ReviewsCubit, ReviewsState>(
                  listener: (context, state) {
                    if (state is ReviewsActionSuccess) {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(state.message)));
                      // Refresh profile
                      // Since we are popping dialog, we need access to FreelancerCubit from page context
                      // But FreelancerProfileScreen rebuilds? No.
                      // We need to trigger reload in parent.
                      // Accessing FreelancerCubit?
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
                        style: TextStyle(color: AppColors.primary),
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
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 15,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BlocBuilder<FreelancerCubit, FreelancerState>(
          builder: (context, state) {
            return ElevatedButton(
              onPressed: () {
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
                    size: 16.sp,
                  ),
                  SizedBox(width: 8.w),
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
            Text(
              'اختر الخدمة',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cairo',
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
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
                    color: const Color(0xFFFAFAFA),
                    borderRadius: BorderRadius.circular(12.r),
                    border: Border.all(color: const Color(0xFFE5E5E5)),
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
                              style: TextStyle(
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Cairo',
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
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      Text(
                        '${service.price} ر.س',
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: AppColors.gold,
                          fontFamily: 'Cairo',
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
