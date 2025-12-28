import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/core/error/exceptions.dart';
import 'package:ehtirafy_app/core/constants/app_mock_data.dart';
import 'package:ehtirafy_app/features/client/contract/data/models/contract_details_model.dart';
import 'package:ehtirafy_app/features/client/contract/data/models/contract_model.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_entity.dart';
import 'package:ehtirafy_app/features/client/contract/domain/repositories/contract_repository.dart';
import 'package:ehtirafy_app/features/client/contract/data/datasources/contract_remote_data_source.dart';
import 'package:ehtirafy_app/features/shared/profile/domain/entities/user_role.dart';

/// Implementation of ContractRepository
///
/// ## Backend Naming Convention
/// - `freelancer` = Photographer/publisher (our app's **Freelancer**)
/// - `customer` = Client who requests services (our app's **Customer**)
class ContractRepositoryImpl implements ContractRepository {
  final ContractRemoteDataSource? remoteDataSource;

  ContractRepositoryImpl({this.remoteDataSource});

  @override
  Future<Either<Failure, ContractDetailsEntity>> getContractDetails(
    String id,
  ) async {
    try {
      if (remoteDataSource == null) {
        throw Exception("RemoteDataSource not initialized");
      }
      final result = await remoteDataSource!.getContractDetails(id);
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ContractEntity>>> getContracts({
    UserRole? userRole,
    Map<String, dynamic>? params,
  }) async {
    try {
      if (remoteDataSource == null) {
        return const Right([]);
      }

      // Build query parameters with user_type based on role
      final queryParams = Map<String, dynamic>.from(params ?? {});

      if (userRole != null) {
        // Backend API accepts: 'freelancer' or 'customer'
        switch (userRole) {
          case UserRole.freelancer:
            queryParams['user_type'] = 'freelancer';
            break;
          case UserRole.client:
            queryParams['user_type'] = 'customer';
            break;
          case UserRole.guest:
            // Guests shouldn't access contracts
            return const Right([]);
        }
      }

      final contracts = await remoteDataSource!.getContracts(queryParams);
      return Right(contracts);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ContractEntity>> updateContractStatus(
    String id,
    String status, {
    bool isPhotographer = false,
    String? noteText,
  }) async {
    try {
      if (remoteDataSource == null) {
        throw Exception("RemoteDataSource not initialized");
      }

      // Use ContractModel helper to create the status update body
      // This maps: isPhotographer (freelancer) → freelancer, !isPhotographer → customer
      final body = ContractModel.createStatusUpdateBody(
        isPhotographer: isPhotographer,
        status: status,
        noteText: noteText,
      );

      final contract = await remoteDataSource!.updateContract(id, body);
      return Right(contract);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
