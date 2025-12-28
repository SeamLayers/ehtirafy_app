import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import '../entities/freelancer_order_entity.dart';

abstract class FreelancerOrdersRepository {
  /// Get all orders for the freelancer
  Future<Either<Failure, List<FreelancerOrderEntity>>> getOrders();

  /// Accept an incoming order
  Future<Either<Failure, FreelancerOrderEntity>> acceptOrder(String orderId);

  /// Reject an incoming order
  Future<Either<Failure, void>> rejectOrder(String orderId);

  /// Get order details
  Future<Either<Failure, FreelancerOrderEntity>> getOrderDetails(
    String orderId,
  );

  /// Complete an order
  Future<Either<Failure, void>> completeOrder(String orderId);
}
