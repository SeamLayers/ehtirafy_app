import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/widgets/images/app_cached_network_image.dart';
import 'package:ehtirafy_app/core/widgets/error_state_widget.dart';
import '../cubit/freelancer_dashboard_cubit.dart';
import '../cubit/freelancer_dashboard_state.dart';
import '../widgets/stat_card.dart';
import '../../domain/entities/gig_entity.dart';
import '../../domain/entities/portfolio_item_entity.dart';
import '../../domain/entities/freelancer_last_contract.dart';

class FreelancerDashboardScreen extends StatefulWidget {
  const FreelancerDashboardScreen({super.key});

  @override
  State<FreelancerDashboardScreen> createState() =>
      _FreelancerDashboardScreenState();
}

class _FreelancerDashboardScreenState extends State<FreelancerDashboardScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FreelancerDashboardCubit>().loadDashboard();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        body: Column(
          children: [
            _buildDarkHeader(context),
            Expanded(
              child:
                  BlocBuilder<
                    FreelancerDashboardCubit,
                    FreelancerDashboardState
                  >(
                    builder: (context, state) {
                      if (state is FreelancerDashboardLoading) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      }

                      if (state is FreelancerDashboardError) {
                        return ErrorStateWidget(
                          message: state.message,
                          retryText: 'إعادة المحاولة',
                          onRetry: () => context
                              .read<FreelancerDashboardCubit>()
                              .loadDashboard(),
                        );
                      }

                      if (state is FreelancerDashboardLoaded) {
                        return RefreshIndicator(
                          color: AppColors.primary,
                          onRefresh: () => context
                              .read<FreelancerDashboardCubit>()
                              .loadDashboard(),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: AppSpacing.md),
                                _buildHeader(context, state),
                                SizedBox(height: AppSpacing.lg),
                                _buildStatsSection(context, state),
                                SizedBox(height: AppSpacing.lg),
                                _buildPortfolioSection(
                                  context,
                                  state.portfolioItems,
                                ),
                                SizedBox(height: AppSpacing.lg),
                                _buildGigsSection(context, state.gigs),
                                SizedBox(height: AppSpacing.lg),
                                _buildRecentOrdersSection(
                                  context,
                                  state.lastContracts,
                                ),
                                SizedBox(height: AppSpacing.xl),
                              ],
                            ),
                          ),
                        );
                      }

                      return const SizedBox.shrink();
                    },
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDarkHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.18),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF24251F), AppColors.dark],
            ),
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 16.h),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 22.w,
                      height: 2.5.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Text(
                      AppStrings.navDashboard.tr(),
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.textLight,
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        height: 1.50,
                      ),
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Container(
                      width: 22.w,
                      height: 2.5.h,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2.r),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, FreelancerDashboardLoaded state) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${AppStrings.freelancerDashboardWelcome.tr()}،',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Row(
                children: [
                  Flexible(
                    child: Text(
                      state.userName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: AppColors.textPrimary,
                        fontSize: 20.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 8.w,
                      vertical: 3.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.star_rounded,
                          color: AppColors.primary,
                          size: 16.sp,
                        ),
                        SizedBox(width: 2.w),
                        Text(
                          '${state.stats.averageRating}',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppColors.textPrimary,
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(width: AppSpacing.sm),
        // Online toggle
        _buildOnlineToggle(context, state),
      ],
    );
  }

  Widget _buildOnlineToggle(
    BuildContext context,
    FreelancerDashboardLoaded state,
  ) {
    final Color statusColor = state.isOnline
        ? AppColors.success
        : AppColors.grey500;
    return Material(
      color: Colors.transparent,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(20.r),
        onTap: () {
          context.read<FreelancerDashboardCubit>().toggleOnlineStatus(
            !state.isOnline,
          );
        },
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 7.h),
          decoration: BoxDecoration(
            color: statusColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: statusColor.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8.w,
                height: 8.h,
                decoration: BoxDecoration(
                  color: statusColor,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: statusColor.withValues(alpha: 0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
              SizedBox(width: 6.w),
              Text(
                state.isOnline
                    ? AppStrings.freelancerDashboardOnline.tr()
                    : AppStrings.freelancerDashboardOffline.tr(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: statusColor,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatsSection(
    BuildContext context,
    FreelancerDashboardLoaded state,
  ) {
    return Row(
      children: [
        Expanded(
          child: StatCard(
            title: AppStrings.freelancerDashboardTotalEarnings.tr(),
            value:
                '${state.stats.totalEarnings == 0 ? "0.00" : state.stats.totalEarnings.toStringAsFixed(2)} ر.س',
            icon: Icons.account_balance_wallet_outlined,
            iconColor: AppColors.primary,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: StatCard(
            title: AppStrings.freelancerDashboardActiveOrders.tr(),
            value: '${state.stats.activeGigs}',
            icon: Icons.assignment_outlined,
            iconColor: AppColors.success,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: StatCard(
            title: AppStrings.freelancerDashboardProfileViews.tr(),
            value: '${0}', // Profile views not in API
            icon: Icons.visibility_outlined,
            iconColor: AppColors.info,
          ),
        ),
      ],
    );
  }

  Widget _buildPortfolioSection(
    BuildContext context,
    List<PortfolioItemEntity> items,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          AppStrings.freelancerDashboardPortfolioSection.tr(),
          AppStrings.freelancerDashboardManagePortfolio.tr(),
          () async {
            await context.push('/freelancer/portfolio');
            if (!context.mounted) return;
            // Always reload when returning from portfolio list
            context.read<FreelancerDashboardCubit>().loadDashboard();
          },
        ),
        SizedBox(height: 12.h),
        if (items.isEmpty)
          _buildEmptyPortfolioCard(context)
        else
          SizedBox(
            height: 150.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(vertical: 4.h),
              itemCount: items.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final item = items[index];
                return _buildPortfolioItem(context, item);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildPortfolioItem(BuildContext context, PortfolioItemEntity item) {
    return Container(
      width: 140.w,
      height: 140.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(18.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            AppCachedNetworkImage(
              imageUrl: item.image ?? '',
              fit: BoxFit.cover,
              memCacheWidth: 384,
              memCacheHeight: 384,
              errorWidget: Container(
                color: AppColors.grey100,
                child: Icon(
                  Icons.image_outlined,
                  color: AppColors.grey400,
                  size: 32.sp,
                ),
              ),
            ),
            // Gradient overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                    stops: const [0.0, 0.5, 1.0],
                  ),
                ),
              ),
            ),
            // Title overlay
            Positioned(
              bottom: 8.h,
              left: 8.w,
              right: 8.w,
              child: Text(
                item.title,
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  fontFamily: 'Cairo',
                  shadows: [
                    Shadow(
                      color: Colors.black.withValues(alpha: 0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyPortfolioCard(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: () async {
        final result = await context.push('/freelancer/portfolio/add');
        if (!context.mounted) return;
        if (result == true) {
          context.read<FreelancerDashboardCubit>().loadDashboard();
        }
      },
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: AppColors.primary.withValues(alpha: 0.5),
          strokeWidth: 1.5,
          gap: 5.0,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_photo_alternate_outlined,
                  size: 32.sp,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                AppStrings.freelancerDashboardEmptyPortfolio.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: AppSpacing.xs),
              Text(
                AppStrings.freelancerDashboardAddFirstWork.tr(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 12.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGigsSection(BuildContext context, List<GigEntity> gigs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          AppStrings.freelancerDashboardServicesSection.tr(),
          AppStrings.freelancerDashboardAddService.tr(),
          () async {
            final result = await context.push('/freelancer/gigs/create');
            if (!context.mounted) return;
            if (result == true) {
              context.read<FreelancerDashboardCubit>().loadDashboard();
            }
          },
          onTitleTap: () async {
            await context.push('/freelancer/gigs');
            if (!context.mounted) return;
            // Always reload when returning from list, as changes might have happened there
            context.read<FreelancerDashboardCubit>().loadDashboard();
          },
        ),
        SizedBox(height: 12.h),
        if (gigs.isEmpty)
          _buildEmptyGigsCard(context)
        else
          SizedBox(
            height: 180.h,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(vertical: 4.h),
              itemCount: gigs.length,
              separatorBuilder: (_, __) => SizedBox(width: 12.w),
              itemBuilder: (context, index) {
                final gig = gigs[index];
                return _buildGigPreviewCard(context, gig);
              },
            ),
          ),
      ],
    );
  }

  Widget _buildGigPreviewCard(BuildContext context, GigEntity gig) {
    final bool isActive = gig.status == GigStatus.active;
    return Container(
      width: 220.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 14,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image with gradient overlay
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(18.r)),
                child: AppCachedNetworkImage(
                  imageUrl: gig.coverImage,
                  width: double.infinity,
                  height: 80.h,
                  fit: BoxFit.cover,
                  memCacheWidth: 440,
                  memCacheHeight: 160,
                  errorWidget: Container(
                    color: AppColors.grey100,
                    child: Icon(
                      Icons.camera_alt,
                      size: 32.sp,
                      color: AppColors.primary,
                    ),
                  ),
                ),
              ),
              // Gradient overlay
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(18.r),
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
              // Status badge
              Positioned(
                top: 8.h,
                right: 8.w,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.success : AppColors.grey600,
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    isActive ? 'نشط' : 'معلق',
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w600,
                      fontFamily: 'Cairo',
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Content
          Padding(
            padding: EdgeInsets.all(12.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title
                Text(
                  gig.title,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: AppSpacing.xs),
                // Category badge
                if (gig.categoryName.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: Text(
                      gig.categoryName,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                      ),
                    ),
                  ),
                SizedBox(height: 6.h),
                // Price
                Row(
                  children: [
                    Icon(
                      Icons.monetization_on_outlined,
                      size: 14.sp,
                      color: AppColors.gold,
                    ),
                    SizedBox(width: AppSpacing.xs),
                    Text(
                      '${gig.price.toInt()} ريال',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.gold,
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyGigsCard(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(18.r),
      onTap: () async {
        final result = await context.push('/freelancer/gigs/create');
        if (!context.mounted) return;
        if (result == true) {
          context.read<FreelancerDashboardCubit>().loadDashboard();
        }
      },
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: AppColors.primary.withValues(alpha: 0.5),
          strokeWidth: 1.5,
          gap: 5.0,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18.r),
          ),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.add_business_outlined,
                  size: 32.sp,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                AppStrings.freelancerDashboardEmptyServices.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRecentOrdersSection(
    BuildContext context,
    List<FreelancerLastContract> orders,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          context,
          AppStrings.freelancerDashboardRecentRequests.tr(),
          AppStrings.freelancerDashboardViewAll.tr(),
          () {
            // Navigate to orders tab (index 2)
          },
        ),
        SizedBox(height: 12.h),
        if (orders.isEmpty)
          _buildEmptyOrdersPlaceholder(context)
        else
          ...orders.map(
            (order) => Padding(
              padding: EdgeInsets.only(bottom: 12.h),
              child: _buildOrderPreviewCard(context, order),
            ),
          ),
      ],
    );
  }

  Widget _buildEmptyOrdersPlaceholder(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(14.w),
            decoration: const BoxDecoration(
              color: AppColors.grey100,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.inbox_outlined,
              size: 32.sp,
              color: AppColors.grey400,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            'لا توجد طلبات حتى الآن',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: AppColors.textSecondary,
              fontSize: 14.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
          Text(
            'ستظهر الطلبات الجديدة هنا',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.grey500,
              fontSize: 12.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderPreviewCard(
    BuildContext context,
    FreelancerLastContract order,
  ) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Client initials avatar instead of photo
          Container(
            width: 44.w,
            height: 44.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.r),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFC8A44F), Color(0xFFD4AF37)],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Text(
                _getClientInitials(order.clientName),
                style: TextStyle(
                  color: AppColors.textLight,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w700,
                  fontFamily: 'Cairo',
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.textPrimary,
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                Text(
                  order.clientName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: AppColors.textSecondary,
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: AppSpacing.sm),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Text(
              '${order.amount.toInt()} ر.س',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppColors.primary,
                fontSize: 12.sp,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context,
    String title,
    String actionText,
    VoidCallback onAction, {
    VoidCallback? onTitleTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: InkWell(
            onTap: onTitleTap,
            borderRadius: BorderRadius.circular(8.r),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 4.w,
                  height: 18.h,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: onAction,
          style: TextButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            actionText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  String _getClientInitials(String name) {
    if (name.isEmpty) return '?';
    final parts = name.trim().split(' ');
    if (parts.length >= 2) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return parts[0][0].toUpperCase();
  }
}

class _DashedBorderPainter extends CustomPainter {
  final Color color;
  final double strokeWidth;
  final double gap;

  _DashedBorderPainter({
    required this.color,
    this.strokeWidth = 1.0,
    this.gap = 5.0,
  });

  @override
  void paint(Canvas canvas, Size size) {
    var paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    var path = Path();
    path.addRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(0, 0, size.width, size.height),
        Radius.circular(18.r),
      ),
    );

    Path dashPath = Path();
    double distance = 0.0;
    for (var pathMetric in path.computeMetrics()) {
      while (distance < pathMetric.length) {
        dashPath.addPath(
          pathMetric.extractPath(distance, distance + gap),
          Offset.zero,
        );
        distance += gap * 2;
      }
    }
    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(_DashedBorderPainter oldDelegate) {
    return color != oldDelegate.color ||
        strokeWidth != oldDelegate.strokeWidth ||
        gap != oldDelegate.gap;
  }
}
