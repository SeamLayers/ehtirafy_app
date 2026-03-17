import 'package:flutter/foundation.dart';
import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import 'package:ehtirafy_app/core/error/exceptions.dart';
import 'package:ehtirafy_app/features/client/contract/data/datasources/contract_remote_data_source.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_entity.dart';
import 'package:ehtirafy_app/features/shared/profile/domain/entities/user_role.dart';
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

      // Map contracts to request entities
      final requests = contracts
          .map((contract) => _mapContractToRequest(contract))
          .toList();

      return Right(requests);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  /// Map ContractEntity to RequestEntity for UI display
  RequestEntity _mapContractToRequest(ContractEntity contract) {
    return RequestModel(
      id: contract.id.toString(),
      serviceName: contract.serviceTitle ?? 'خدمة تصوير',
      photographerName: contract.photographerName ?? 'مصور',
      photographerId: contract.photographerId,
      advertisementId: contract.advertisementId,
      photographerImage: contract.photographerImage ?? '',
      status: _mapContractStatusToRequestStatus(contract),
      price: double.tryParse(contract.requestedAmount) ?? 0,
      date: contract.createdAt,
      isPaymentRequired:
          contract.displayStatus == ContractStatus.pendingPayment,
      approvedDate: contract.displayStatus == ContractStatus.inProgress
          ? contract.updatedAt
          : null,
    );
  }

  /// Map contract status to RequestStatus enum
  /// - pending → underReview (waiting for photographer)
  /// - pendingPayment → active (waiting for customer payment)
  /// - awaitingAdminReview → active (payment submitted, awaiting admin verification)
  /// - inProgress → active (contract is active)
  /// - completed → completed
  /// - rejected/cancelled/archived → cancelled
  RequestStatus _mapContractStatusToRequestStatus(ContractEntity contract) {
    final status = contract.displayStatus;
    switch (status) {
      case ContractStatus.pending:
        return RequestStatus.underReview;
      case ContractStatus.pendingPayment:
      case ContractStatus.awaitingAdminReview:
      case ContractStatus.inProgress:
        return RequestStatus.active;
      case ContractStatus.completed:
        return RequestStatus.completed;
      case ContractStatus.rejected:
      case ContractStatus.cancelled:
      case ContractStatus.archived:
        return RequestStatus.cancelled;
    }
  }
}
