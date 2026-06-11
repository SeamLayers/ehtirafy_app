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
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/contract_header.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/contract_info_card.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/contract_status_widgets.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/payment_status_card.dart';
import 'package:ehtirafy_app/features/client/booking/presentation/widgets/states/order_details_completed_view.dart';
import 'package:ehtirafy_app/features/client/booking/presentation/widgets/states/order_details_cancelled_view.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/widgets/work_stages_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ContractDetailsScreen extends StatelessWidget {
  final String contractId;

  const ContractDetailsScreen({super.key, required this.contractId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocProvider(
      create: (context) =>
          sl<ContractDetailsCubit>()..getContractDetails(contractId),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          backgroundColor: AppColors.backgroundLight,
          surfaceTintColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Text(
            AppStrings.contractDetailsTitle.tr(),
            style: theme.textTheme.titleMedium?.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                ) ??
                TextStyle(
                  color: AppColors.textPrimary,
                  fontFamily: 'Cairo',
                  fontSize: 17.sp,
                  fontWeight: FontWeight.w700,
                ),
          ),
          leading: const RtlBackButton(),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.h),
            child: Container(
              height: 1.h,
              color: AppColors.grey200,
            ),
          ),
        ),
        body: BlocBuilder<ContractDetailsCubit, ContractDetailsState>(
          builder: (context, state) {
            if (state is ContractDetailsLoading) {
              return const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
                ),
              );
            } else if (state is ContractDetailsError) {
              return ErrorStateWidget(
                message: state.message.tr(),
                retryText: AppStrings.confirm.tr(),
                onRetry: () => context
                    .read<ContractDetailsCubit>()
                    .getContractDetails(contractId),
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

  Widget _buildContent(BuildContext context, ContractDetailsEntity contract) {
    final isActiveContract =
        contract.status == ContractStatus.inProgress ||
        contract.status == ContractStatus.pendingPayment ||
        contract.status == ContractStatus.awaitingAdminReview;

    if (contract.status == ContractStatus.initiated ||
        contract.status == ContractStatus.pending) {
      return SingleChildScrollView(
        padding: EdgeInsets.all(AppSpacing.md),
        child: ContractUnderReviewCard(contract: contract),
      );
    }

    if (contract.status == ContractStatus.completed) {
      return OrderDetailsCompletedView(contract: contract);
    }

    if (contract.status == ContractStatus.cancelled ||
        contract.status == ContractStatus.rejected) {
      return OrderDetailsCancelledView(contract: contract);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ContractHeader(contract: contract),
          SizedBox(height: AppSpacing.md),
          ContractThreeStatusCard(contract: contract),
          SizedBox(height: AppSpacing.md),
          ContractInfoCard(contract: contract),
          SizedBox(height: AppSpacing.md),
          if (isActiveContract) ...[
            PaymentStatusCard(contract: contract),
            SizedBox(height: AppSpacing.md),
            WorkStagesList(contract: contract),
            SizedBox(height: AppSpacing.md),
            ContractInProgressActions(
              onChatPressed: () {
                // Navigate to chat
                context.push(
                  '/chat/conversation',
                  extra: {
                    'id': contract.id.toString(),
                    'name': contract.photographerName,
                    'image': contract.photographerImage,
                    'userType': 'customer',
                  },
                );
              },
              onCompletePressed: () {
                showDialog(
                  context: context,
                  builder: (ctx) => AlertDialog(
                    backgroundColor: Colors.white,
                    surfaceTintColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    titlePadding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.lg,
                      AppSpacing.sm,
                    ),
                    contentPadding: EdgeInsets.fromLTRB(
                      AppSpacing.lg,
                      0,
                      AppSpacing.lg,
                      AppSpacing.sm,
                    ),
                    title: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(8.w),
                          decoration: BoxDecoration(
                            color: AppColors.success.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.check_circle_outline_rounded,
                            color: AppColors.success,
                            size: 22.sp,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            AppStrings.contractFinishService.tr(),
                            style: TextStyle(
                              color: AppColors.textPrimary,
                              fontFamily: 'Cairo',
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                    content: Text(
                      'هل أنت متأكد من إكمال هذا العقد؟ لا يمكن التراجع عن هذا الإجراء.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontFamily: 'Cairo',
                        fontSize: 14.sp,
                        height: 1.5,
                      ),
                    ),
                    actionsPadding: EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      0,
                      AppSpacing.md,
                      AppSpacing.md,
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.textSecondary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                        ),
                        child: Text(
                          AppStrings.cancel.tr(),
                          style: TextStyle(
                            fontFamily: 'Cairo',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(ctx);
                          context.read<ContractDetailsCubit>().completeContract(
                            contract.id.toString(),
                          );
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.error,
                          backgroundColor:
                              AppColors.error.withValues(alpha: 0.08),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.md,
                            vertical: AppSpacing.sm,
                          ),
                        ),
                        child: Text(
                          AppStrings.confirm.tr(),
                          style: TextStyle(
                            color: AppColors.error,
                            fontFamily: 'Cairo',
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
          SizedBox(height: AppSpacing.xl),
        ],
      ),
    );
  }
}
