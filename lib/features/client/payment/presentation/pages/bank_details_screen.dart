import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/di/service_locator.dart';
import '../../../../../core/theme/app_colors.dart';
import '../cubit/bank_details_cubit.dart';
import '../cubit/bank_details_state.dart';
import '../cubit/payment_proof_cubit.dart';
import '../widgets/bank_details_card.dart';

class BankDetailsScreen extends StatefulWidget {
  final String contractId;

  const BankDetailsScreen({
    super.key,
    required this.contractId,
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
    return Scaffold(
      appBar: AppBar(
        title: Text('bank_details_title'.tr()),
        centerTitle: true,
      ),
      body: BlocConsumer<BankDetailsCubit, BankDetailsState>(
        listener: (context, state) {
          if (state is BankDetailsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BankDetailsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is BankDetailsError) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.red,
                      size: 80.sp,
                    ),
                    SizedBox(height: 16.h),
                    Text(
                      state.message,
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.sp),
                    ),
                    SizedBox(height: 32.h),
                    ElevatedButton(
                      onPressed: () {
                        context.read<BankDetailsCubit>().fetchBankDetails();
                      },
                      child: Text('retry'.tr()),
                    ),
                  ],
                ),
              ),
            );
          }

          if (state is BankDetailsLoaded) {
            return SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Instructions
                  Container(
                    padding: EdgeInsets.all(12.w),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(8.r),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Text(
                      'bank_details_instruction'.tr(),
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.blue.shade900,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(height: 24.h),

                  // Bank Account Details Card
                  BankDetailsCard(bankAccount: state.bankAccount),
                  SizedBox(height: 32.h),

                  // Proceed to Payment Proof Button
                  SizedBox(
                    height: 56.h,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.r),
                        ),
                      ),
                      onPressed: () {
                        // Navigate to payment proof screen
                        context.push(
                          '/payment/proof/${ widget.contractId}',
                        );
                      },
                      child: Text(
                        'proceed_to_payment_proof'.tr(),
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16.h),
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
