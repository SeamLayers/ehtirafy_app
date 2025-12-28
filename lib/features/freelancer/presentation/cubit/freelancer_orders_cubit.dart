import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/freelancer_order_entity.dart';
import '../../domain/repositories/freelancer_orders_repository.dart';
import 'freelancer_orders_state.dart';

class FreelancerOrdersCubit extends Cubit<FreelancerOrdersState> {
  final FreelancerOrdersRepository repository;

  FreelancerOrdersCubit({required this.repository})
    : super(FreelancerOrdersInitial());

  Future<void> loadOrders() async {
    emit(FreelancerOrdersLoading());

    final result = await repository.getOrders();

    result.fold((failure) => emit(FreelancerOrdersError(failure.message)), (
      orders,
    ) {
      // Initial filter: Tab 0 (Pending/Requests)
      final filtered = _filterOrders(orders, 0);
      emit(
        FreelancerOrdersLoaded(
          allOrders: orders,
          filteredOrders: filtered,
          selectedTabIndex: 0,
        ),
      );
    });
  }

  void changeTab(int index) {
    if (state is FreelancerOrdersLoaded) {
      final currentState = state as FreelancerOrdersLoaded;
      final filtered = _filterOrders(currentState.allOrders, index);
      emit(
        currentState.copyWith(
          selectedTabIndex: index,
          filteredOrders: filtered,
        ),
      );
    }
  }

  Future<void> acceptOrder(String orderId) async {
    if (state is FreelancerOrdersLoaded) {
      final currentState = state as FreelancerOrdersLoaded;

      final result = await repository.acceptOrder(orderId);

      result.fold((failure) => emit(FreelancerOrdersError(failure.message)), (
        updatedOrder,
      ) {
        // Update the order in the list
        final updatedOrders = currentState.allOrders.map((order) {
          if (order.id == orderId) {
            return updatedOrder;
          }
          return order;
        }).toList();

        final filtered = _filterOrders(
          updatedOrders,
          currentState.selectedTabIndex,
        );
        emit(
          currentState.copyWith(
            allOrders: updatedOrders,
            filteredOrders: filtered,
          ),
        );
      });
    }
  }

  Future<void> rejectOrder(String orderId) async {
    if (state is FreelancerOrdersLoaded) {
      final currentState = state as FreelancerOrdersLoaded;

      final result = await repository.rejectOrder(orderId);

      result.fold((failure) => emit(FreelancerOrdersError(failure.message)), (
        _,
      ) {
        // Update the order status to cancelled in the list
        final updatedOrders = currentState.allOrders.map((order) {
          if (order.id == orderId) {
            // Create a new order with cancelled status
            return FreelancerOrderEntity(
              id: order.id,
              serviceTitle: order.serviceTitle,
              clientName: order.clientName,
              clientImage: order.clientImage,
              status: FreelancerOrderStatus.cancelled,
              price: order.price,
              location: order.location,
              eventDate: order.eventDate,
              createdAt: order.createdAt,
            );
          }
          return order;
        }).toList();

        final filtered = _filterOrders(
          updatedOrders,
          currentState.selectedTabIndex,
        );
        emit(
          currentState.copyWith(
            allOrders: updatedOrders,
            filteredOrders: filtered,
          ),
        );
      });
    }
  }

  List<FreelancerOrderEntity> _filterOrders(
    List<FreelancerOrderEntity> orders,
    int tabIndex,
  ) {
    switch (tabIndex) {
      case 0: // Requests (Pending)
        return orders
            .where((o) => o.status == FreelancerOrderStatus.pending)
            .toList();
      case 1: // Active (In Progress)
        return orders
            .where((o) => o.status == FreelancerOrderStatus.inProgress)
            .toList();
      case 2: // Archived (Completed or Cancelled)
        return orders
            .where(
              (o) =>
                  o.status == FreelancerOrderStatus.completed ||
                  o.status == FreelancerOrderStatus.cancelled,
            )
            .toList();
      default:
        return orders;
    }
  }

  Future<void> completeOrder(String orderId) async {
    if (state is FreelancerOrdersLoaded) {
      final currentState = state as FreelancerOrdersLoaded;

      final result = await repository.completeOrder(orderId);

      result.fold((failure) => emit(FreelancerOrdersError(failure.message)), (
        _,
      ) {
        // Update the order status to completed in the list
        final updatedOrders = currentState.allOrders.map((order) {
          if (order.id == orderId) {
            return FreelancerOrderEntity(
              id: order.id,
              serviceTitle: order.serviceTitle,
              clientName: order.clientName,
              clientImage: order.clientImage,
              status: FreelancerOrderStatus.completed,
              price: order.price,
              location: order.location,
              eventDate: order.eventDate,
              createdAt: order.createdAt,
            );
          }
          return order;
        }).toList();

        final filtered = _filterOrders(
          updatedOrders,
          currentState.selectedTabIndex,
        );
        emit(
          currentState.copyWith(
            allOrders: updatedOrders,
            filteredOrders: filtered,
          ),
        );
      });
    }
  }
}
