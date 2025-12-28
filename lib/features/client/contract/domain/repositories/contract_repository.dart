import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_entity.dart';
import 'package:ehtirafy_app/features/shared/profile/domain/entities/user_role.dart';

/// Repository for contract operations
abstract class ContractRepository {
  /// Get detailed contract information by ID
  Future<Either<Failure, ContractDetailsEntity>> getContractDetails(String id);

  /// Fetch contracts from API
  /// [userRole] determines the user_type query parameter:
  /// - UserRole.freelancer → user_type=freelancer (photographer)
  /// - UserRole.client → user_type=customer
  Future<Either<Failure, List<ContractEntity>>> getContracts({
    UserRole? userRole,
    Map<String, dynamic>? params,
  });

  /// Update contract status
  ///
  /// [isPhotographer] determines which status field to update:
  /// - true → contr_pub_status (accepted, rejected, completed)
  /// - false → contr_cust_status (cancelled, completed)
  ///
  /// [noteText] sends optional message with status update
  Future<Either<Failure, ContractEntity>> updateContractStatus(
    String id,
    String status, {
    bool isPhotographer = false,
    String? noteText,
  });
}
