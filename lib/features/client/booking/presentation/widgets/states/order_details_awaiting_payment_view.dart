import 'package:ehtirafy_app/features/client/booking/presentation/widgets/states/awaiting_payment/approved_status_card.dart';
import 'package:ehtirafy_app/features/client/booking/presentation/widgets/states/awaiting_payment/post_payment_timeline.dart';
import 'package:ehtirafy_app/features/client/booking/presentation/widgets/states/awaiting_payment/timer_banner.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderDetailsAwaitingPaymentView extends StatelessWidget {
  final ContractDetailsEntity contract;

  const OrderDetailsAwaitingPaymentView({super.key, required this.contract});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9F9F9),
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TimerBanner(),
              SizedBox(height: 16.h),
              ApprovedStatusCard(contract: contract),
              SizedBox(height: 16.h),
              const PostPaymentTimeline(),
            ],
          ),
        ),
      ),
    );
  }
}
