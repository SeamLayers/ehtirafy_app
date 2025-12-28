import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ehtirafy_app/features/client/contract/domain/usecases/update_contract_status_usecase.dart';
import '../../domain/entities/request_entity.dart';
import '../../domain/usecases/get_my_requests_usecase.dart';
import 'requests_state.dart';

class RequestsCubit extends Cubit<RequestsState> {
  final GetMyRequestsUseCase getMyRequestsUseCase;

  RequestsCubit(this.getMyRequestsUseCase) : super(RequestsInitial());

  Future<void> getRequests() async {
    emit(RequestsLoading());
    final result = await getMyRequestsUseCase();
    result.fold((failure) => emit(RequestsError(failure.message)), (requests) {
      // Initial filter: Active requests (Tab 0)
      // Tab 0: Active (Status: active)
      // Tab 1: Under Review (Status: underReview)
      // Tab 2: Completed (Status: completed or cancelled)

      final initialFiltered = _filterRequests(requests, 0);
      emit(
        RequestsLoaded(
          allRequests: requests,
          filteredRequests: initialFiltered,
          selectedTabIndex: 0,
        ),
      );
    });
  }

  void changeTab(int index) {
    if (state is RequestsLoaded) {
      final currentState = state as RequestsLoaded;
      final filtered = _filterRequests(currentState.allRequests, index);
      emit(
        currentState.copyWith(
          selectedTabIndex: index,
          filteredRequests: filtered,
        ),
      );
    }
  }

  List<RequestEntity> _filterRequests(
    List<RequestEntity> requests,
    int tabIndex,
  ) {
    switch (tabIndex) {
      case 0: // Active
        return requests.where((r) => r.status == RequestStatus.active).toList();
      case 1: // Under Review
        return requests
            .where((r) => r.status == RequestStatus.underReview)
            .toList();
      case 2: // Completed (Completed or Cancelled)
        return requests
            .where(
              (r) =>
                  r.status == RequestStatus.completed ||
                  r.status == RequestStatus.cancelled,
            )
            .toList();
      default:
        return requests;
    }
  }

  /// Pay a contract by updating its status to 'Paid'
  Future<void> payContract(
    String contractId,
    UpdateContractStatusUseCase updateContractStatusUseCase,
  ) async {
    final result = await updateContractStatusUseCase(
      id: contractId,
      status: 'Paid',
      isPhotographer: false, // Customer action
    );

    result.fold((failure) => emit(RequestsError(failure.message)), (
      success,
    ) async {
      // Refresh the list after successful payment
      await getRequests();
    });
  }
}
