import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/error_state_widget.dart';
import 'package:ehtirafy_app/core/widgets/rtl_back_button.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/manager/contract_details_cubit.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/manager/contract_details_state.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/backend_contract_status_ui.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/contract_header.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/contract_info_card.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/contract_status_widgets.dart';
import 'package:ehtirafy_app/features/client/booking/presentation/widgets/states/order_details_pending_view.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/work_stages_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:ehtirafy_app/features/shared/auth/presentation/cubits/role_cubit.dart';
import 'package:ehtirafy_app/features/shared/auth/domain/entities/user_role.dart';

class OrderDetailsScreen extends StatelessWidget {
  final String orderId;

  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          sl<ContractDetailsCubit>()..getContractDetails(orderId),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: _buildAppBar(),
        body: BlocBuilder<ContractDetailsCubit, ContractDetailsState>(
          builder: (context, state) {
            if (state is ContractDetailsLoading) {
              return Center(
                child: SizedBox(
                  width: 40.r,
                  height: 40.r,
                  child: const CircularProgressIndicator(
                    strokeWidth: 3,
                    valueColor:
                        AlwaysStoppedAnimation<Color>(AppColors.gold),
                  ),
                ),
              );
            } else if (state is ContractDetailsError) {
              return ErrorStateWidget(
                message: state.message.tr(),
                onRetry: () => context
                    .read<ContractDetailsCubit>()
                    .getContractDetails(orderId),
                retryText: AppStrings.retry.tr(),
              );
            } else if (state is ContractDetailsSuccess) {
              return _buildContent(context, state.contract);
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  /// Premium AppBar: white surface, centered Cairo title, and a subtle
  /// gold underline that anchors the brand identity to the top of the screen.
  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      scrolledUnderElevation: 0,
      centerTitle: true,
      title: Text(
        AppStrings.contractDetailsTitle.tr(),
        style: TextStyle(
          fontFamily: 'Cairo',
          color: AppColors.textPrimary,
          fontSize: 17.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      leading: const RtlBackButton(),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(2.h),
        child: Container(
          height: 2.h,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.centerStart,
              end: AlignmentDirectional.centerEnd,
              colors: [
                AppColors.gold.withValues(alpha: 0.0),
                AppColors.gold.withValues(alpha: 0.55),
                AppColors.gold.withValues(alpha: 0.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context, ContractDetailsEntity contract) {
    // Determine user role
    final roleState = sl<RoleCubit>().state;
    bool isFreelancer = false;
    if (roleState is RoleLoaded) {
      isFreelancer = roleState.role == UserRole.freelancer;
    } else if (roleState is RoleSaved) {
      isFreelancer = roleState.role == UserRole.freelancer;
    } else {
      isFreelancer = sl<RoleCubit>().selected == UserRole.freelancer;
    }

    // State 1: Pending Approval from Freelancer
    if (contract.status == ContractStatus.initiated ||
        contract.status == ContractStatus.pending) {
      return OrderDetailsPendingView(contract: contract);
    }

    // Active states in current backend flow.
    if (contract.status == ContractStatus.inProgress ||
        contract.status == ContractStatus.pendingPayment ||
        contract.status == ContractStatus.awaitingAdminReview) {
      return SingleChildScrollView(
        padding: EdgeInsetsDirectional.fromSTEB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _ContractStatusStepper(contract: contract),
            SizedBox(height: AppSpacing.lg),
            ContractHeader(contract: contract),
            SizedBox(height: AppSpacing.lg),
            ContractInfoCard(contract: contract, isFreelancer: isFreelancer),
            SizedBox(height: AppSpacing.lg),
            WorkStagesList(contract: contract),
            SizedBox(height: AppSpacing.lg),
            const ContractInProgressActions(),
          ],
        ),
      );
    }

    // State 4: Completed or Cancelled
    return SingleChildScrollView(
      padding: EdgeInsetsDirectional.fromSTEB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContractHeader(contract: contract),
          SizedBox(height: AppSpacing.lg),
          ContractInfoCard(contract: contract, isFreelancer: isFreelancer),
          // Add specific UI for completed/cancelled if needed, e.g. Rate Button
          if (contract.status == ContractStatus.completed) Container(),
        ],
      ),
    );
  }
}

/// Compact, elegant lifecycle stepper for the active contract layouts.
///
/// Steps: Initiate -> Approved -> In progress -> Completed.
/// The active step is derived ONLY from
/// backendContractStatusUi(canonicalBackendContractStatus(...)) — no
/// per-status colors are hardcoded for the active node, which always uses
/// the brand gold per spec. Completed nodes are gold-filled with a white
/// check; future nodes are grey outlines.
class _ContractStatusStepper extends StatelessWidget {
  final ContractDetailsEntity contract;

  const _ContractStatusStepper({required this.contract});

  @override
  Widget build(BuildContext context) {
    final isArabic =
        context.locale.languageCode.toLowerCase().startsWith('ar');

    final canonical = canonicalBackendContractStatus(
      contract.contractStatus ?? contract.status.name,
    );
    final activeIndex = _activeIndexFor(canonical);

    final labels = <String>[
      isArabic ? 'بدء' : 'Initiate',
      isArabic ? 'موافقة' : 'Approved',
      isArabic ? 'قيد التنفيذ' : 'In progress',
      isArabic ? 'مكتمل' : 'Completed',
    ];

    return Container(
      width: double.infinity,
      padding: EdgeInsetsDirectional.fromSTEB(
        AppSpacing.md,
        AppSpacing.lg,
        AppSpacing.md,
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.gold.withValues(alpha: 0.10),
            blurRadius: 18.r,
            spreadRadius: -2,
            offset: Offset(0, 6.h),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: List.generate(labels.length, (index) {
          final isLast = index == labels.length - 1;
          return Expanded(
            child: _StepCell(
              label: labels[index],
              index: index,
              activeIndex: activeIndex,
              isLast: isLast,
            ),
          );
        }),
      ),
    );
  }

  int _activeIndexFor(String canonical) {
    switch (canonical) {
      case 'Initiate':
        return 0;
      case 'Approved':
        return 1;
      case 'InProgress':
        return 2;
      case 'Closed':
        return 3;
      default:
        // Cancelled / Rejected / unknown — keep early in the flow without
        // implying completion.
        return 0;
    }
  }
}

class _StepCell extends StatelessWidget {
  final String label;
  final int index;
  final int activeIndex;
  final bool isLast;

  const _StepCell({
    required this.label,
    required this.index,
    required this.activeIndex,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final bool isDone = index < activeIndex;
    final bool isActive = index == activeIndex;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            _buildNode(isDone: isDone, isActive: isActive),
            if (!isLast)
              Expanded(
                child: Container(
                  height: 3.h,
                  margin: EdgeInsetsDirectional.symmetric(horizontal: 4.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2.r),
                    gradient: index < activeIndex
                        ? LinearGradient(
                            colors: [
                              AppColors.gold,
                              AppColors.gold.withValues(alpha: 0.55),
                            ],
                          )
                        : null,
                    color:
                        index < activeIndex ? null : AppColors.grey200,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: AppSpacing.sm),
        Padding(
          padding: EdgeInsetsDirectional.only(end: isLast ? 0 : 8.w),
          child: Text(
            label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: 10.5.sp,
              height: 1.2,
              fontWeight:
                  isActive ? FontWeight.w700 : FontWeight.w600,
              color: (isDone || isActive)
                  ? AppColors.textPrimary
                  : AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNode({required bool isDone, required bool isActive}) {
    if (isDone) {
      return Container(
        width: 24.r,
        height: 24.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.gold,
              AppColors.gold.withValues(alpha: 0.82),
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.gold.withValues(alpha: 0.30),
              blurRadius: 6.r,
              offset: Offset(0, 2.h),
            ),
          ],
        ),
        child: Icon(Icons.check_rounded, color: Colors.white, size: 14.r),
      );
    }

    if (isActive) {
      return Container(
        width: 28.r,
        height: 28.r,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: AppColors.gold.withValues(alpha: 0.14),
          border: Border.all(
            color: AppColors.gold.withValues(alpha: 0.40),
            width: 2,
          ),
        ),
        child: Center(
          child: Container(
            width: 16.r,
            height: 16.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.gold,
              boxShadow: [
                BoxShadow(
                  color: AppColors.gold.withValues(alpha: 0.40),
                  blurRadius: 6.r,
                  offset: Offset(0, 2.h),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Future node
    return Container(
      width: 24.r,
      height: 24.r,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white,
        border: Border.all(color: AppColors.grey200, width: 2),
      ),
    );
  }
}
