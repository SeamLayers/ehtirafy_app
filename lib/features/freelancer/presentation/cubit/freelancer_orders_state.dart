import 'package:equatable/equatable.dart';
import '../../domain/entities/freelancer_order_entity.dart';

abstract class FreelancerOrdersState extends Equatable {
  const FreelancerOrdersState();

  @override
  List<Object?> get props => [];
}

class FreelancerOrdersInitial extends FreelancerOrdersState {}

class FreelancerOrdersLoading extends FreelancerOrdersState {}

class FreelancerOrdersLoaded extends FreelancerOrdersState {
  final List<FreelancerOrderEntity> allOrders;
  final List<FreelancerOrderEntity> filteredOrders;
  final int selectedTabIndex;

  const FreelancerOrdersLoaded({
    required this.allOrders,
    required this.filteredOrders,
    required this.selectedTabIndex,
  });

  @override
  List<Object?> get props => [allOrders, filteredOrders, selectedTabIndex];

  FreelancerOrdersLoaded copyWith({
    List<FreelancerOrderEntity>? allOrders,
    List<FreelancerOrderEntity>? filteredOrders,
    int? selectedTabIndex,
  }) {
    return FreelancerOrdersLoaded(
      allOrders: allOrders ?? this.allOrders,
      filteredOrders: filteredOrders ?? this.filteredOrders,
      selectedTabIndex: selectedTabIndex ?? this.selectedTabIndex,
    );
  }
}

class FreelancerOrdersError extends FreelancerOrdersState {
  final String message;

  const FreelancerOrdersError(this.message);

  @override
  List<Object?> get props => [message];
}

class FreelancerOrderActionLoading extends FreelancerOrdersState {
  final String orderId;

  const FreelancerOrderActionLoading(this.orderId);

  @override
  List<Object?> get props => [orderId];
}
