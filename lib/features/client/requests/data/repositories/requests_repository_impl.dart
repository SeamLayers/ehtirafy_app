import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import 'package:ehtirafy_app/core/errors/exceptions.dart';
import 'package:ehtirafy_app/features/client/contract/data/datasources/contract_remote_data_source.dart';
import 'package:ehtirafy_app/features/shared/profile/domain/entities/user_role.dart';
import 'package:ehtirafy_app/features/shared/orders/data/models/shared_order_model.dart';
import 'package:ehtirafy_app/features/shared/orders/domain/entities/shared_order_entity.dart';
import '../../domain/entities/request_entity.dart';
import '../../domain/repositories/requests_repository.dart';
import '../models/request_model.dart';

/// Repository implementation for fetching user requests/contracts
///
/// Uses ContractRemoteDataSource to fetch contracts from API
/// and maps them to RequestEntity for the UI
///
/// ## Backend Naming Convention
/// - `freelancer` = Photographer/publisher (our app's **Freelancer**)
/// - `customer` = Client who requests services (our app's **Customer**)
class RequestsRepositoryImpl implements RequestsRepository {
  final ContractRemoteDataSource remoteDataSource;
  final UserRole userRole;

  RequestsRepositoryImpl({
    required this.remoteDataSource,
    this.userRole = UserRole.client,
  });

  @override
  Future<Either<Failure, List<RequestEntity>>> getMyRequests() async {
    try {
      // Backend API accepts: 'freelancer' or 'customer'
      // Client/customer uses 'customer' to get their contracts
      final userType = 'customer';

      // Debug log
      debugPrint('🔍 RequestsRepositoryImpl - userRole: $userRole');
      debugPrint('🔍 RequestsRepositoryImpl - sending user_type: $userType');

      final contracts = await remoteDataSource.getContracts({
        'user_type': userType,
      });

      final requests = contracts.map((contract) {
        final sharedOrder = SharedOrderModel.fromContract(
          contract,
        ).toEntityForClient();
        return _mapSharedOrderToRequest(sharedOrder);
      }).toList();

      return Right(requests);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  RequestEntity _mapSharedOrderToRequest(SharedOrderEntity sharedOrder) {
    return RequestModel(
      id: sharedOrder.id,
      serviceName: sharedOrder.serviceTitle.isEmpty
          ? 'خدمة تصوير'
          : sharedOrder.serviceTitle,
      photographerName: sharedOrder.counterpartyName.isEmpty
          ? 'مصور'
          : sharedOrder.counterpartyName,
      photographerId: sharedOrder.counterpartyId,
      advertisementId: sharedOrder.advertisementId,
      photographerImage: sharedOrder.counterpartyImage,
      status: _mapSharedStatusToRequestStatus(sharedOrder.status),
      price: sharedOrder.price,
      date: sharedOrder.createdAt,
      isPaymentRequired: sharedOrder.isPaymentRequired,
      approvedDate: sharedOrder.approvedDate,
    );
  }

  RequestStatus _mapSharedStatusToRequestStatus(SharedOrderStatus status) {
    switch (status) {
      case SharedOrderStatus.pending:
        return RequestStatus.underReview;
      case SharedOrderStatus.pendingPayment:
      case SharedOrderStatus.awaitingAdminReview:
      case SharedOrderStatus.inProgress:
        return RequestStatus.active;
      case SharedOrderStatus.completed:
        return RequestStatus.completed;
      case SharedOrderStatus.cancelled:
      case SharedOrderStatus.archived:
        return RequestStatus.cancelled;
    }
  }
}
