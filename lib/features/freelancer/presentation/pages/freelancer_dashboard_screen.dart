import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
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
        backgroundColor: const Color(0xFFF9F9F9),
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
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (state is FreelancerDashboardError) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(state.message),
                              SizedBox(height: 16.h),
                              ElevatedButton(
                                onPressed: () => context
                                    .read<FreelancerDashboardCubit>()
                                    .loadDashboard(),
                                child: const Text('إعادة المحاولة'),
                              ),
                            ],
                          ),
                        );
                      }

                      if (state is FreelancerDashboardLoaded) {
                        return RefreshIndicator(
                          onRefresh: () => context
                              .read<FreelancerDashboardCubit>()
                              .loadDashboard(),
                          child: SingleChildScrollView(
                            physics: const AlwaysScrollableScrollPhysics(),
                            padding: EdgeInsets.symmetric(horizontal: 16.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 16.h),
                                _buildHeader(context, state),
                                SizedBox(height: 24.h),
                                _buildStatsSection(context, state),
                                SizedBox(height: 24.h),
                                _buildPortfolioSection(
                                  context,
                                  state.portfolioItems,
                                ),
                                SizedBox(height: 24.h),
                                _buildGigsSection(context, state.gigs),
                                SizedBox(height: 24.h),
                                _buildRecentOrdersSection(
                                  context,
                                  state.lastContracts,
                                ),
                                SizedBox(height: 32.h),
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
      color: AppColors.dark,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: const BoxDecoration(
            color: AppColors.dark,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Center(
            child: Text(
              AppStrings.navDashboard.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                height: 1.50,
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
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${AppStrings.freelancerDashboardWelcome.tr()}،',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: const Color(0xFF888888),
                fontSize: 14.sp,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Text(
                  state.userName,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: const Color(0xFF2B2B2B),
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(width: 8.w),
                Row(
                  children: [
                    Icon(Icons.star, color: AppColors.primary, size: 16.sp),
                    SizedBox(width: 2.w),
                    Text(
                      '${state.stats.averageRating}',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFF2B2B2B),
                        fontSize: 12.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        // Online toggle
        _buildOnlineToggle(context, state),
      ],
    );
  }

  Widget _buildOnlineToggle(
    BuildContext context,
    FreelancerDashboardLoaded state,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: state.isOnline
            ? const Color(0xFF28A745).withOpacity(0.1)
            : const Color(0xFF888888).withOpacity(0.1),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: state.isOnline
              ? const Color(0xFF28A745).withOpacity(0.3)
              : const Color(0xFF888888).withOpacity(0.3),
        ),
      ),
      child: InkWell(
        onTap: () {
          context.read<FreelancerDashboardCubit>().toggleOnlineStatus(
            !state.isOnline,
          );
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8.w,
              height: 8.h,
              decoration: BoxDecoration(
                color: state.isOnline
                    ? const Color(0xFF28A745)
                    : const Color(0xFF888888),
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              state.isOnline
                  ? AppStrings.freelancerDashboardOnline.tr()
                  : AppStrings.freelancerDashboardOffline.tr(),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: state.isOnline
                    ? const Color(0xFF28A745)
                    : const Color(0xFF888888),
                fontSize: 12.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
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
            iconColor: const Color(0xFF28A745),
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: StatCard(
            title: AppStrings.freelancerDashboardProfileViews.tr(),
            value: '${0}', // Profile views not in API
            icon: Icons.visibility_outlined,
            iconColor: const Color(0xFF17A2B8),
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
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16.r),
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Image
            Image.network(
              item.image ?? '',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                color: const Color(0xFFF5F5F5),
                child: Icon(Icons.image, color: Colors.grey, size: 32.sp),
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
                  color: Colors.white,
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
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
      onTap: () async {
        final result = await context.push('/freelancer/portfolio/add');
        if (result == true) {
          context.read<FreelancerDashboardCubit>().loadDashboard();
        }
      },
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: AppColors.primary.withOpacity(0.5),
          strokeWidth: 1.5,
          gap: 5.0,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Icon(
                Icons.add_photo_alternate_outlined,
                size: 48.sp,
                color: AppColors.primary,
              ),
              SizedBox(height: 12.h),
              Text(
                AppStrings.freelancerDashboardEmptyPortfolio.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF2B2B2B),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                AppStrings.freelancerDashboardAddFirstWork.tr(),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: const Color(0xFF888888),
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
            if (result == true) {
              context.read<FreelancerDashboardCubit>().loadDashboard();
            }
          },
          onTitleTap: () async {
            await context.push('/freelancer/gigs');
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
    return Container(
      width: 220.w,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x1A000000),
            blurRadius: 12,
            offset: const Offset(0, 4),
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
                borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
                child: Image.network(
                  gig.coverImage,
                  width: double.infinity,
                  height: 80.h,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    width: double.infinity,
                    height: 80.h,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          AppColors.primary.withValues(alpha: 0.1),
                          AppColors.gold.withValues(alpha: 0.1),
                        ],
                      ),
                    ),
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
                      top: Radius.circular(16.r),
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
                    color: gig.status == GigStatus.active
                        ? const Color(0xFF28A745)
                        : const Color(0xFF6C757D),
                    borderRadius: BorderRadius.circular(8.r),
                  ),
                  child: Text(
                    gig.status == GigStatus.active ? 'نشط' : 'معلق',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
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
                    color: const Color(0xFF2B2B2B),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 4.h),
                // Category badge
                if (gig.categoryName.isNotEmpty)
                  Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: 6.w,
                      vertical: 2.h,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(4.r),
                    ),
                    child: Text(
                      gig.categoryName,
                      style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 10.sp,
                        fontWeight: FontWeight.w500,
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
                    SizedBox(width: 4.w),
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
      onTap: () async {
        final result = await context.push('/freelancer/gigs/create');
        if (result == true) {
          context.read<FreelancerDashboardCubit>().loadDashboard();
        }
      },
      child: CustomPaint(
        painter: _DashedBorderPainter(
          color: AppColors.primary.withOpacity(0.5),
          strokeWidth: 1.5,
          gap: 5.0,
        ),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(24.w),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
          ),
          child: Column(
            children: [
              Icon(
                Icons.add_business_outlined,
                size: 48.sp,
                color: AppColors.primary,
              ),
              SizedBox(height: 12.h),
              Text(
                AppStrings.freelancerDashboardEmptyServices.tr(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF2B2B2B),
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
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
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: const Color(0xFFEEEEEE)),
      ),
      child: Column(
        children: [
          Icon(
            Icons.inbox_outlined,
            size: 48.sp,
            color: const Color(0xFFCCCCCC),
          ),
          SizedBox(height: 12.h),
          Text(
            'لا توجد طلبات حتى الآن',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: const Color(0xFF888888),
              fontSize: 14.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            'ستظهر الطلبات الجديدة هنا',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: const Color(0xFFAAAAAA),
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
        borderRadius: BorderRadius.circular(12.r),
        boxShadow: [
          BoxShadow(
            color: const Color(0x0D000000),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Client initials avatar instead of photo
          Container(
            width: 40.w,
            height: 40.h,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.r),
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFFC8A44F), Color(0xFFD4AF37)],
              ),
            ),
            child: Center(
              child: Text(
                _getClientInitials(order.clientName),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
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
                    color: const Color(0xFF2B2B2B),
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  order.clientName,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF888888),
                    fontSize: 11.sp,
                  ),
                ),
              ],
            ),
          ),
          Text(
            '${order.amount.toInt()} ر.س',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w600,
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
        InkWell(
          onTap: onTitleTap,
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              color: const Color(0xFF2B2B2B),
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        TextButton(
          onPressed: onAction,
          child: Text(
            actionText,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
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
        Radius.circular(16.r),
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
