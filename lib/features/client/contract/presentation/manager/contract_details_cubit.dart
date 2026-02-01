import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/features/client/contract/domain/usecases/get_contract_details_usecase.dart';
import 'package:ehtirafy_app/features/client/contract/domain/usecases/update_contract_status_usecase.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/manager/contract_details_state.dart';
import 'package:ehtirafy_app/features/client/contract/domain/usecases/confirm_payment_usecase.dart';
import 'package:ehtirafy_app/features/shared/payment/services/payment_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContractDetailsCubit extends Cubit<ContractDetailsState> {
  final GetContractDetailsUseCase getContractDetailsUseCase;

  final UpdateContractStatusUseCase updateContractStatusUseCase;

  final ConfirmPaymentUseCase confirmPaymentUseCase;

  ContractDetailsCubit({
    required this.getContractDetailsUseCase,
    required this.updateContractStatusUseCase,
    required this.confirmPaymentUseCase,
  }) : super(ContractDetailsInitial());

  Future<void> getContractDetails(String id) async {
    emit(ContractDetailsLoading());
    final result = await getContractDetailsUseCase(id);
    result.fold(
      (failure) =>
          (failure) => emit(ContractDetailsError(failure.message)),
      (contract) {
        // Configure Payment SDK with session (optional, safe to call multiple times or in init)
        PaymentService.configureSdk();
        emit(ContractDetailsSuccess(contract));
      },
    );
  }

  Future<void> payContract(String id, double amount) async {
    // 1. Show loading (optional, or rely on UI to block)
    // We don't emit Loading here effectively because we want to keep the UI visible for the payment sheet
    // But usage: "Show a Loading Indicator while paying" if purely simulation. 
    // If real SDK, it handles its own UI. 
    
    // Using PaymentService to determine flow
    await PaymentService.startPayment(
      amount: amount,
      transactionId: id,
      customerEmail: "user@example.com", // TODO: Get from profile/user session
      customerPhone: "12345678", // TODO: Get from profile
      onSuccess: (response) async {
        // Handle Success
        emit(
          ContractDetailsLoading(),
        ); // Show spinner while confirming with backend
        
        final result = await confirmPaymentUseCase(id);

        result.fold(
          (failure) =>
              emit(
            const ContractDetailsError(
              "Payment successful but backend update failed",
            ),
          ),
          (success) {
            // Success Logic
            if (state is ContractDetailsSuccess) {
              // Refresh or Update local state
              // We can just re-emit success with new data from result
              // Assuming result is the updated ContractEntity matching strict structure
               
              // Re-fetch or simplistic update
              // For robustness, let's fetch fresh details to match expected ContractDetailsEntity
              getContractDetails(id);
            } else {
              getContractDetails(id);
            }
          },
        );
      },
      onFailure: (response) {
        // Handle Failure
        // emit(ContractDetailsError(response?.message ?? "Payment Failed"));
        // Or just show toast
      },
    );
  }

  // kept for backward compatibility if needed, or other status updates
  Future<void> completeContract(
    String id, {
    bool isPhotographer = false,
  }) async {
    emit(ContractDetailsLoading());

    // Call update status to 'Completed'
    final result = await updateContractStatusUseCase(
      id: id,
      status: 'Completed',
      isPhotographer: isPhotographer,
    );

    result.fold(
      (failure) =>
          emit(const ContractDetailsError(AppStrings.failureUnexpected)),
      (success) async {
        if (state is ContractDetailsSuccess) {
          // Simple re-fetch is safer than manual map manipulation if fields are complex
          // but let's stick to previous pattern if efficient
          await getContractDetails(id);
        } else {
          await getContractDetails(id);
        }
      },
    );
  }
}
