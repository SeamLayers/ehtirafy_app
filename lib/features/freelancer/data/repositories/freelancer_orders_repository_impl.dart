import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import 'package:ehtirafy_app/core/errors/exceptions.dart';
import 'package:ehtirafy_app/features/client/contract/data/datasources/contract_remote_data_source.dart';
import 'package:ehtirafy_app/features/freelancer/domain/entities/freelancer_order_entity.dart';
import 'package:ehtirafy_app/features/freelancer/domain/repositories/freelancer_orders_repository.dart';
import 'package:ehtirafy_app/features/shared/orders/data/models/shared_order_model.dart';
import 'package:ehtirafy_app/features/shared/orders/domain/entities/shared_order_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FreelancerOrdersRepositoryImpl implements FreelancerOrdersRepository {
  final ContractRemoteDataSource remoteDataSource;
  final SharedPreferences sharedPreferences;

  FreelancerOrdersRepositoryImpl({
    required this.remoteDataSource,
    required this.sharedPreferences,
  });

  @override
  Future<Either<Failure, List<FreelancerOrderEntity>>> getOrders() async {
    try {
      final contracts = await remoteDataSource.getContracts({
        'user_type': 'freelancer',
      });

      final orders = contracts.map((contract) {
        final sharedOrder = SharedOrderModel.fromContract(
          contract,
        ).toEntityForFreelancer();
        return _mapSharedOrderToFreelancerOrder(sharedOrder);
      }).toList();

      return Right(orders);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FreelancerOrderEntity>> acceptOrder(
    String orderId,
  ) async {
    try {
      final contract = await remoteDataSource.updateContract(orderId, {
        'note_type': 'freelancer',
        'contr_pub_status': 'Approved',
        'note_text': 'تم قبول الطلب',
        '_method': 'put',
      });

      return Right(
        _mapSharedOrderToFreelancerOrder(
          SharedOrderModel.fromContract(contract).toEntityForFreelancer(),
        ),
      );
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> rejectOrder(String orderId) async {
    try {
      await remoteDataSource.updateContract(orderId, {
        'note_type': 'freelancer',
        'contr_pub_status': 'Rejected',
        'note_text': 'تم رفض الطلب',
        '_method': 'PUT',
      });
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> completeOrder(String orderId) async {
    try {
      await remoteDataSource.updateContract(orderId, {
        'note_type': 'freelancer',
        'contr_pub_status': 'Completed',
        'note_text': 'تم تسليم العمل بنجاح',
        '_method': 'PUT',
      });
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, FreelancerOrderEntity>> getOrderDetails(
    String orderId,
  ) async {
    try {
      final contracts = await remoteDataSource.getContracts({
        'user_type': 'freelancer',
        'id': orderId,
      });
      if (contracts.isNotEmpty) {
        final sharedOrder = SharedOrderModel.fromContract(
          contracts.first,
        ).toEntityForFreelancer();
        return Right(
          _mapSharedOrderToFreelancerOrder(sharedOrder),
        );
      }
      return const Left(ServerFailure('Order not found'));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  FreelancerOrderEntity _mapSharedOrderToFreelancerOrder(
    SharedOrderEntity sharedOrder,
  ) {
    return FreelancerOrderEntity(
      id: sharedOrder.id,
      serviceTitle: sharedOrder.serviceTitle.isEmpty
          ? 'Requested Service'
          : sharedOrder.serviceTitle,
      clientName: sharedOrder.counterpartyName.isEmpty
          ? 'Unknown Client'
          : sharedOrder.counterpartyName,
      clientImage: sharedOrder.counterpartyImage,
      status: _mapSharedStatus(sharedOrder.status),
      price: sharedOrder.price,
      location: 'Remote',
      eventDate: sharedOrder.createdAt,
      createdAt: sharedOrder.createdAt,
    );
  }

  FreelancerOrderStatus _mapSharedStatus(SharedOrderStatus status) {
    switch (status) {
      case SharedOrderStatus.pending:
        return FreelancerOrderStatus.pending;
      case SharedOrderStatus.pendingPayment:
      case SharedOrderStatus.awaitingAdminReview:
      case SharedOrderStatus.inProgress:
        return FreelancerOrderStatus.inProgress;
      case SharedOrderStatus.completed:
        return FreelancerOrderStatus.completed;
      case SharedOrderStatus.cancelled:
      case SharedOrderStatus.archived:
        return FreelancerOrderStatus.cancelled;
    }
  }
}
