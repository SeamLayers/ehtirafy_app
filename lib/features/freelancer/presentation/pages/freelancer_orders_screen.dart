import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import '../cubit/freelancer_orders_cubit.dart';
import '../cubit/freelancer_orders_state.dart';
import '../widgets/freelancer_order_card.dart';
import '../widgets/orders_filter_tab.dart';
import 'package:ehtirafy_app/core/widgets/outlined_refresh_button.dart';
import 'package:ehtirafy_app/core/widgets/custom_empty_state.dart';
import 'package:ehtirafy_app/core/widgets/error_state_widget.dart';

class FreelancerOrdersScreen extends StatefulWidget {
  const FreelancerOrdersScreen({super.key});

  @override
  State<FreelancerOrdersScreen> createState() => _FreelancerOrdersScreenState();
}

class _FreelancerOrdersScreenState extends State<FreelancerOrdersScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FreelancerOrdersCubit>().loadOrders();
  }

  // The financial pledge is shown ONLY when publishing a new advertisement,
  // not when accepting an order. Accept directly here.
  void _acceptOrder(String orderId) {
    context.read<FreelancerOrdersCubit>().acceptOrder(orderId);
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
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<FreelancerOrdersCubit, FreelancerOrdersState>(
                builder: (context, state) {
                  if (state is FreelancerOrdersLoading) {
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5.r,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.gold,
                        ),
                      ),
                    );
                  }

                  if (state is FreelancerOrdersError) {
                    return ErrorStateWidget(
                      message: state.message,
                      onRetry: () =>
                          context.read<FreelancerOrdersCubit>().loadOrders(),
                    );
                  }

                  if (state is FreelancerOrdersLoaded) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsetsDirectional.fromSTEB(
                            AppSpacing.lg,
                            AppSpacing.md,
                            AppSpacing.lg,
                            0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedRefreshButton(
                                onPressed: () {
                                  context
                                      .read<FreelancerOrdersCubit>()
                                      .loadOrders();
                                },
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                        Padding(
                          padding: EdgeInsetsDirectional.symmetric(
                            horizontal: AppSpacing.lg,
                          ),
                          child: OrdersFilterTab(
                            selectedIndex: state.selectedTabIndex,
                            onTabSelected: (index) {
                              context.read<FreelancerOrdersCubit>().changeTab(
                                index,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: AppSpacing.lg),
                        Expanded(
                          child: AnimatedSwitcher(
                            duration: const Duration(milliseconds: 300),
                            child: state.filteredOrders.isEmpty
                                ? _buildEmptyState(
                                    context,
                                    state.selectedTabIndex,
                                  )
                                : ListView.separated(
                                    key: ValueKey<int>(state.selectedTabIndex),
                                    padding: EdgeInsetsDirectional.only(
                                      start: AppSpacing.lg,
                                      end: AppSpacing.lg,
                                      bottom: AppSpacing.lg,
                                    ),
                                    itemCount: state.filteredOrders.length,
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: AppSpacing.md),
                                    itemBuilder: (context, index) {
                                      final order = state.filteredOrders[index];
                                      return GestureDetector(
                                        onTap: () => context.push(
                                          '/freelancer/orders/details',
                                          extra: order,
                                        ),
                                        child: FreelancerOrderCard(
                                          order: order,
                                          onAccept: state.selectedTabIndex == 0
                                              ? () => _acceptOrder(order.id)
                                              : null,
                                          onReject: state.selectedTabIndex == 0
                                              ? () => context
                                                    .read<
                                                      FreelancerOrdersCubit
                                                    >()
                                                    .rejectOrder(order.id)
                                              : null,
                                          onViewDetails:
                                              state.selectedTabIndex == 1
                                              ? () => context.push(
                                                  '/freelancer/orders/details',
                                                  extra: order,
                                                )
                                              : null,
                                          onChat: state.selectedTabIndex == 1
                                              ? () {}
                                              : null,
                                        ),
                                      );
                                    },
                                  ),
                          ),
                        ),
                      ],
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

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.dark,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
          decoration: BoxDecoration(
            color: AppColors.dark,
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.18),
                blurRadius: 16.r,
                offset: Offset(0, 6.h),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 30.w,
                  height: 30.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.gold.withValues(alpha: 0.16),
                    border: Border.all(
                      color: AppColors.gold.withValues(alpha: 0.45),
                      width: 1,
                    ),
                  ),
                  child: Icon(
                    Icons.receipt_long_rounded,
                    size: 16.sp,
                    color: AppColors.gold,
                  ),
                ),
                SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    AppStrings.freelancerOrdersTitle.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w700,
                      height: 1.50,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, int tabIndex) {
    String message;
    IconData icon;

    switch (tabIndex) {
      case 0:
        message = AppStrings.freelancerOrdersNoRequests.tr();
        icon = Icons.inbox_outlined;
        break;
      case 1:
        message = AppStrings.freelancerOrdersNoActiveOrders.tr();
        icon = Icons.assignment_outlined;
        break;
      case 2:
        message = AppStrings.freelancerOrdersNoArchivedOrders.tr();
        icon = Icons.archive_outlined;
        break;
      default:
        message = '';
        icon = Icons.inbox_outlined;
    }

    return Center(
      child: EmptyStateWidget(
        message: message,
        icon: icon,
      ),
    );
  }
}
