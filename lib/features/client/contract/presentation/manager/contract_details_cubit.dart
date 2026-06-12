import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/features/client/contract/domain/usecases/get_contract_details_usecase.dart';
import 'package:ehtirafy_app/features/client/contract/domain/usecases/update_contract_status_usecase.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/manager/contract_details_state.dart';
import 'package:ehtirafy_app/features/client/contract/domain/usecases/confirm_payment_usecase.dart';
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
      (failure) => emit(ContractDetailsError(failure.message)),
      (contract) => emit(ContractDetailsSuccess(contract)),
    );
  }

  // Expose this for Mock Payment Screen to call directly
  Future<void> confirmPayment(String id) async {
    emit(
      ContractDetailsLoading(),
    ); // Show spinner while confirming with backend

    final result = await confirmPaymentUseCase(id);

    result.fold(
      (failure) => emit(
        ContractDetailsError(
          "Payment successful but backend update failed: ${failure.message}",
        ),
      ),
      (success) {
        // Success Logic
        if (state is ContractDetailsSuccess) {
          getContractDetails(id);
        } else {
          getContractDetails(id);
        }
      },
    );
  }

  Future<void> payContract(String id, double amount) async {
    // Manual transfer flow no longer starts SDK payment from cubit.
    // Kept for backward compatibility in case old UI still calls this method.
    await confirmPayment(id);
  }

  /// Cancel a pending (Initiate) contract.
  ///
  /// The backend state machine does NOT accept `Closed`/`Cancelled` directly
  /// from `Initiate` — the valid customer transition is `Rejected`, which the
  /// backend then moves to the terminal `Closed` state. Verified live against
  /// `front/contract/{id}/update`.
  Future<void> cancelContract(String id, {bool isPhotographer = false}) async {
    emit(ContractDetailsLoading());

    final result = await updateContractStatusUseCase(
      id: id,
      status: 'Rejected',
      isPhotographer: isPhotographer,
    );

    result.fold(
      (failure) => emit(ContractDetailsError(failure.message)),
      (_) async => await getContractDetails(id),
    );
  }

  // kept for backward compatibility if needed, or other status updates
  Future<void> completeContract(
    String id, {
    bool isPhotographer = false,
  }) async {
    emit(ContractDetailsLoading());

    // In the new backend flow, freelancer actions keep contract in progress,
    // and final completion is confirmed by customer.
    final targetStatus = isPhotographer ? 'InProgress' : 'Completed';

    final result = await updateContractStatusUseCase(
      id: id,
      status: targetStatus,
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
