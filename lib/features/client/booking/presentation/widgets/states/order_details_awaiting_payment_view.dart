import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/features/client/booking/presentation/widgets/states/awaiting_payment/approved_status_card.dart';
import 'package:ehtirafy_app/features/client/booking/presentation/widgets/states/awaiting_payment/post_payment_timeline.dart';
import 'package:ehtirafy_app/features/client/booking/presentation/widgets/states/awaiting_payment/timer_banner.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:flutter/material.dart';

class OrderDetailsAwaitingPaymentView extends StatelessWidget {
  final ContractDetailsEntity contract;

  const OrderDetailsAwaitingPaymentView({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.backgroundLight,
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.xl,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const TimerBanner(),
            SizedBox(height: AppSpacing.md),
            ApprovedStatusCard(contract: contract),
            SizedBox(height: AppSpacing.md),
            const PostPaymentTimeline(),
          ],
        ),
      ),
    );
  }
}
