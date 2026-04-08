import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:ehtirafy_app/features/client/booking/presentation/widgets/states/order_details_awaiting_payment_view.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/manager/contract_details_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TestPaymentScreen extends StatelessWidget {
  const TestPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a dummy contract for testing
    final dummyContract = ContractDetailsEntity(
      id: "FAKE_TEST_ID_123",
      status: ContractStatus.pending,
      serviceTitle: "Test Photography Service",
      serviceCategory: "Photography",
      description: "This is a mock contract for testing the payment flow.",
      location: "Riyadh, Saudi Arabia",
      date: DateTime.now(), // works
      budget: 150.0,
      isPaymentDeposited: false,
      photographerName: "Test Photographer",
      photographerImage: "", // Empty or placeholder URL
      approvedAt: null,
      contractStatus: "opened",
      publisherId: "999",
      publisherPhone: "123456789",
      publisherEmail: "provider@test.com",
      customerId: "888",
      customerName: "Test Customer",
      customerImage: "",
      customerPhone: "987654321",
      customerEmail: "customer@test.com",
      notes: const [],
      daysAvailability: const [],
    );

    return BlocProvider(
      create: (context) => sl<ContractDetailsCubit>(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Test Payment Flow"),
        ),
        body: OrderDetailsAwaitingPaymentView(contract: dummyContract),
      ),
    );
  }
}
