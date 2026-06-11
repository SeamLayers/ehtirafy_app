import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_spacing.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/widgets/error_state_widget.dart';
import '../../../../../core/widgets/primary_button.dart';
import '../../../../../core/widgets/rtl_back_button.dart';
import '../cubit/bank_details_cubit.dart';
import '../cubit/bank_details_state.dart';
import '../widgets/bank_details_card.dart';

class BankDetailsScreen extends StatefulWidget {
  final String contractId;
  final String advertisementId;

  const BankDetailsScreen({
    super.key,
    required this.contractId,
    required this.advertisementId,
  });

  @override
  State<BankDetailsScreen> createState() => _BankDetailsScreenState();
}

class _BankDetailsScreenState extends State<BankDetailsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<BankDetailsCubit>().fetchBankDetails();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppColors.backgroundLight,
      appBar: AppBar(
        backgroundColor: theme.scaffoldBackgroundColor,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0.5,
        centerTitle: true,
        leading: const RtlBackButton(),
        title: Text(
          'bank_details_title'.tr(),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1.h),
          child: Container(
            height: 1.h,
            color: AppColors.grey200,
          ),
        ),
      ),
      body: BlocConsumer<BankDetailsCubit, BankDetailsState>(
        listener: (context, state) {
          if (state is BankDetailsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BankDetailsLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: const AlwaysStoppedAnimation<Color>(AppColors.gold),
                strokeWidth: 3.w,
              ),
            );
          }

          if (state is BankDetailsError) {
            return ErrorStateWidget(
              message: state.message,
              retryText: 'retry'.tr(),
              onRetry: () {
                context.read<BankDetailsCubit>().fetchBankDetails();
              },
            );
          }

          if (state is BankDetailsLoaded) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Instructions
                  Container(
                    padding: EdgeInsets.all(AppSpacing.md),
                    decoration: BoxDecoration(
                      color: AppColors.gold.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(16.r),
                      border: Border.all(
                        color: AppColors.gold.withValues(alpha: 0.25),
                      ),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(AppSpacing.sm),
                          decoration: BoxDecoration(
                            color: AppColors.gold.withValues(alpha: 0.14),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.info_outline_rounded,
                            size: 20.sp,
                            color: AppColors.gold,
                          ),
                        ),
                        SizedBox(width: AppSpacing.sm),
                        Expanded(
                          child: Text(
                            'bank_details_instruction'.tr(),
                            style: theme.textTheme.bodyMedium?.copyWith(
                              fontSize: 14.sp,
                              color: AppColors.textPrimary,
                              height: 1.5,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: AppSpacing.lg),

                  // Bank Account Details Card
                  BankDetailsCard(bankAccount: state.bankAccount),
                  SizedBox(height: AppSpacing.xl),

                  // Proceed to Payment Proof Button
                  PrimaryButton(
                    text: 'proceed_to_payment_proof'.tr(),
                    onPressed: () {
                      // Navigate to payment proof screen
                      context.push(
                        '/payment/proof/${widget.contractId}?advId=${widget.advertisementId}',
                      );
                    },
                  ),
                  SizedBox(height: AppSpacing.md),
                ],
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
    );
  }
}
