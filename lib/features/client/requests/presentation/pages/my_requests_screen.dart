import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:ehtirafy_app/features/client/contract/data/datasources/contract_remote_data_source.dart';
import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/role_cubit.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/entities/user_role.dart'
    as auth_role;
import 'package:ehtirafy_app/features/shared/profile/domain/entities/user_role.dart';
import '../../data/repositories/requests_repository_impl.dart';
import '../../domain/usecases/get_my_requests_usecase.dart';
import '../cubit/requests_cubit.dart';
import '../cubit/requests_state.dart';
import '../../../booking/presentation/widgets/request_card.dart';
import '../widgets/requests_filter_tab.dart';
import 'package:ehtirafy_app/core/widgets/custom_empty_state.dart';
import 'package:ehtirafy_app/core/widgets/error_state_widget.dart';
import 'package:ehtirafy_app/core/widgets/outlined_refresh_button.dart';

/// My Requests Screen - Shows contracts for both clients and freelancers
///
/// 3 Tabs:
/// - Tab 0: Active (accepted, payment required)
/// - Tab 1: Under Review (pending)
/// - Tab 2: Completed (completed/cancelled)
class MyRequestsScreen extends StatelessWidget {
  const MyRequestsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Get current user role to determine which contracts to fetch
    // Use the RoleCubit's selected getter directly (always has current role)
    final roleCubit = sl<RoleCubit>();
    final authRole = roleCubit.selected;

    // Debug log
    debugPrint('🔍 MyRequestsScreen - authRole from RoleCubit: $authRole');

    // Map from auth.UserRole to profile.UserRole
    UserRole currentRole = authRole == auth_role.UserRole.freelancer
        ? UserRole.freelancer
        : UserRole.client;

    debugPrint('🔍 MyRequestsScreen - mapped currentRole: $currentRole');

    return BlocProvider(
      create: (context) => RequestsCubit(
        GetMyRequestsUseCase(
          RequestsRepositoryImpl(
            remoteDataSource: sl<ContractRemoteDataSource>(),
            userRole: currentRole,
          ),
        ),
      )..getRequests(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.transparent,
        ),
        child: BlocListener<RequestsCubit, RequestsState>(
          listener: (context, state) {
            if (state is RequestsError) {
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
            body: Column(
              children: [
                _buildHeader(context),
                Expanded(
                  child: BlocBuilder<RequestsCubit, RequestsState>(
                    builder: (context, state) {
                      if (state is RequestsLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            color: AppColors.gold,
                            strokeWidth: 2.5.w,
                          ),
                        );
                      } else if (state is RequestsError) {
                        // Keep the specific error widget as well for non-intrusive retry if preferred
                        // or just rely on the SnackBar. The user requested handling "exception... if we got any 400"
                        // The existing ErrorStateWidget is good for fullscreen errors. The SnackBar satisfies the prompt.
                        return ErrorStateWidget(
                          message: state.message,
                          onRetry: () {
                            context.read<RequestsCubit>().getRequests();
                          },
                          retryText: 'إعادة المحاولة',
                        );
                      } else if (state is RequestsLoaded) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsetsDirectional.fromSTEB(
                                24.w,
                                AppSpacing.md,
                                24.w,
                                0,
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  OutlinedRefreshButton(
                                    onPressed: () {
                                      context
                                          .read<RequestsCubit>()
                                          .getRequests();
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: AppSpacing.md),
                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 24.w),
                              child: RequestsFilterTab(
                                selectedIndex: state.selectedTabIndex,
                                onTabSelected: (index) {
                                  context.read<RequestsCubit>().changeTab(
                                    index,
                                  );
                                },
                              ),
                            ),
                            SizedBox(height: AppSpacing.lg),
                            Expanded(
                              child: AnimatedSwitcher(
                                duration: const Duration(milliseconds: 300),
                                child: state.filteredRequests.isEmpty
                                    ? _buildEmptyState(context, state.selectedTabIndex)
                                    : ListView.separated(
                                        key: ValueKey<int>(
                                          state.selectedTabIndex,
                                        ),
                                        padding: EdgeInsets.only(
                                          left: 24.w,
                                          right: 24.w,
                                          bottom: 24.h,
                                        ),
                                        itemCount:
                                            state.filteredRequests.length,
                                        separatorBuilder: (context, index) =>
                                            SizedBox(height: 16.h),
                                        itemBuilder: (context, index) {
                                          final request =
                                              state.filteredRequests[index];
                                          return RequestCard(
                                            request: request,
                                            onPayPressed:
                                                request.isPaymentRequired
                                                ? () {
                                                    context.push(
                                                      '/payment/bank-details/${request.id}?advId=${request.advertisementId}',
                                                    );
                                                  }
                                                : null,
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
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [
                AppColors.dark,
                AppColors.dark.withValues(alpha: 0.92),
              ],
            ),
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.12),
                blurRadius: 16.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.assignment_outlined,
                  color: AppColors.gold,
                  size: 18.sp,
                ),
                SizedBox(width: AppSpacing.sm),
                Flexible(
                  child: Text(
                    AppStrings.myRequestsTitle.tr(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      height: 1.50,
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
    String subMessage;
    IconData icon;
    String? retryText;
    VoidCallback? onRetry;

    switch (tabIndex) {
      case 0: // Active
        message = AppStrings.myRequestsNoRequests.tr();
        subMessage = AppStrings.myRequestsStartRequesting.tr();
        icon = Icons.camera_alt_outlined;
        retryText = AppStrings.myRequestsBrowsePhotographers.tr();
        onRetry = () => context.go('/home');
        break;
      case 1: // Under Review
        message = 'لا توجد طلبات قيد المراجعة';
        subMessage = 'ستظهر هنا الطلبات التي تنتظر الموافقة';
        icon = Icons.pending_actions_outlined;
        break;
      case 2: // Completed
        message = 'لا توجد طلبات مكتملة';
        subMessage = 'ستظهر هنا الطلبات المكتملة والملغاة';
        icon = Icons.history_outlined;
        break;
      default:
        message = AppStrings.myRequestsNoRequests.tr();
        subMessage = AppStrings.myRequestsStartRequesting.tr();
        icon = Icons.camera_alt_outlined;
    }

    return Center(
      child: EmptyStateWidget(
        message: message,
        subMessage: subMessage,
        icon: icon,
        retryText: retryText,
        onRetry: onRetry,
      ),
    );
  }
}
