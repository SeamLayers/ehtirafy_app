import 'package:equatable/equatable.dart';
import '../../domain/entities/request_entity.dart';

abstract class RequestsState extends Equatable {
  const RequestsState();

  @override
  List<Object> get props => [];
}

class RequestsInitial extends RequestsState {}

class RequestsLoading extends RequestsState {}

class RequestsLoaded extends RequestsState {
  final List<RequestEntity> allRequests;
  final List<RequestEntity> filteredRequests;
  final int selectedTabIndex;

  const RequestsLoaded({
    required this.allRequests,
    required this.filteredRequests,
    this.selectedTabIndex = 0,
  });

  RequestsLoaded copyWith({
    List<RequestEntity>? allRequests,
    List<RequestEntity>? filteredRequests,
    int? selectedTabIndex,
  }) {
    return RequestsLoaded(
      allRequests: allRequests ?? this.allRequests,
      filteredRequests: filteredRequests ?? this.filteredRequests,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }

  @override
  List<Object> get props => [allRequests, filteredRequests, selectedTabIndex];
}

class RequestsError extends RequestsState {
  final String message;

  const RequestsError(this.message);

  @override
  List<Object> get props => [message];
}
