import 'package:easy_localization/easy_localization.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/services.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import '../cubit/freelancer_orders_cubit.dart';
import '../cubit/freelancer_orders_state.dart';
import '../widgets/freelancer_order_card.dart';
import '../widgets/orders_filter_tab.dart';
import 'package:ehtirafy_app/core/widgets/outlined_refresh_button.dart';

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
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<FreelancerOrdersCubit, FreelancerOrdersState>(
                builder: (context, state) {
                  if (state is FreelancerOrdersLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is FreelancerOrdersError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(state.message),
                          SizedBox(height: 16.h),
                          ElevatedButton(
                            onPressed: () => context
                                .read<FreelancerOrdersCubit>()
                                .loadOrders(),
                            child: const Text('إعادة المحاولة'),
                          ),
                        ],
                      ),
                    );
                  }

                  if (state is FreelancerOrdersLoaded) {
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
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
                        SizedBox(height: 10.h),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 24.w),
                          child: OrdersFilterTab(
                            selectedIndex: state.selectedTabIndex,
                            onTabSelected: (index) {
                              context.read<FreelancerOrdersCubit>().changeTab(
                                index,
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 24.h),
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
                                    padding: EdgeInsets.only(
                                      left: 24.w,
                                      right: 24.w,
                                      bottom: 24.h,
                                    ),
                                    itemCount: state.filteredOrders.length,
                                    separatorBuilder: (context, index) =>
                                        SizedBox(height: 16.h),
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
                                              ? () => context
                                                    .read<
                                                      FreelancerOrdersCubit
                                                    >()
                                                    .acceptOrder(order.id)
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
              AppStrings.freelancerOrdersTitle.tr(),
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

    return Container(
      width: 349.w,
      height: 268.h,
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14.r),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80.w,
            height: 80.h,
            decoration: ShapeDecoration(
              color: const Color(0xFFF9F9F9),
              shape: RoundedRectangleBorder(
                side: const BorderSide(width: 2, color: Color(0xFFE5E5E5)),
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            child: Icon(icon, size: 40.sp, color: const Color(0xFF888888)),
          ),
          SizedBox(height: 16.h),
          Text(
            message,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: const Color(0xFF2B2B2B),
              fontSize: 16.sp,
              fontWeight: FontWeight.w400,
              height: 1.50,
            ),
          ),
        ],
      ),
    );
  }
}
