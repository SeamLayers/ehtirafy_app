import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/features/client/contract/data/models/contract_details_model.dart';
import 'package:ehtirafy_app/features/client/contract/domain/usecases/get_contract_details_usecase.dart';
import 'package:ehtirafy_app/features/client/contract/domain/usecases/update_contract_status_usecase.dart';
import 'package:ehtirafy_app/features/client/contract/presentation/manager/contract_details_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ContractDetailsCubit extends Cubit<ContractDetailsState> {
  final GetContractDetailsUseCase getContractDetailsUseCase;

  final UpdateContractStatusUseCase updateContractStatusUseCase;

  ContractDetailsCubit({
    required this.getContractDetailsUseCase,
    required this.updateContractStatusUseCase,
  }) : super(ContractDetailsInitial());

  Future<void> getContractDetails(String id) async {
    emit(ContractDetailsLoading());
    final result = await getContractDetailsUseCase(id);
    result.fold(
      (failure) =>
          emit(const ContractDetailsError(AppStrings.failureUnexpected)),
      (contract) => emit(ContractDetailsSuccess(contract)),
    );
  }

  Future<void> payContract(String id) async {
    // 1. Emit loading or keep current state (maybe show loading overlay in UI)
    // For now, we'll re-emit loading to refresh the page after update
    emit(ContractDetailsLoading());

    // 2. Call update status to 'Paid' (or 'InProcess' for customer status)
    // The requirement is "update status Paid ok".
    // Usually 'paid' or 'inprocess'. Let's use 'paid' as per user request example.
    final result = await updateContractStatusUseCase(
      id: id,
      status:
          'Paid', // Capitalized as backend likely expects capitalized values
      isPhotographer: false, // Customer action
    );

    // 3. Handle result
    result.fold(
      (failure) =>
          emit(const ContractDetailsError(AppStrings.failureUnexpected)),
      (success) async {
        // 4. Update local state directly instead of re-fetching mock data
        if (state is ContractDetailsSuccess) {
          final currentDetails = (state as ContractDetailsSuccess).contract;

          // Calculate new derived status
          final statusMap = {
            'contract_status': success.contractStatus,
            'contr_pub_status': success.contrPubStatus,
            'contr_cust_status': success.contrCustStatus,
          };

          // We need ContractDetailsModel for the static method, need import
          // Or duplicate logic if simpler. Let's assume import is added or available.
          // Since we can't easily add import in this block without checking file,
          // I'll replicate the logic here for safety or use the public method if imported.
          // Better to use the public method from Model.
          // Note: success is ContractEntity, convert fields.

          final newStatus = ContractDetailsModel.deriveStatus(statusMap);

          final newDetails = currentDetails.copyWith(
            contractStatus: success.contractStatus,
            contrPubStatus: success.contrPubStatus,
            contrCustStatus: success.contrCustStatus,
            status: newStatus,
          );

          emit(ContractDetailsSuccess(newDetails));
        } else {
          // Fallback if state was somehow lost (unlikely), try fetch (won't work for mock though)
          await getContractDetails(id);
        }
      },
    );
  }

  Future<void> completeContract(String id) async {
    emit(ContractDetailsLoading());

    // Call update status to 'Completed'
    final result = await updateContractStatusUseCase(
      id: id,
      status: 'Completed',
      isPhotographer: false, // Customer action
    );

    result.fold(
      (failure) =>
          emit(const ContractDetailsError(AppStrings.failureUnexpected)),
      (success) async {
        if (state is ContractDetailsSuccess) {
          final currentDetails = (state as ContractDetailsSuccess).contract;

          final statusMap = {
            'contract_status': success.contractStatus,
            'contr_pub_status': success.contrPubStatus,
            'contr_cust_status': success.contrCustStatus,
          };

          final newStatus = ContractDetailsModel.deriveStatus(statusMap);

          final newDetails = currentDetails.copyWith(
            contractStatus: success.contractStatus,
            contrPubStatus: success.contrPubStatus,
            contrCustStatus: success.contrCustStatus,
            status: newStatus,
          );

          emit(ContractDetailsSuccess(newDetails));
        } else {
          await getContractDetails(id);
        }
      },
    );
  }
}
