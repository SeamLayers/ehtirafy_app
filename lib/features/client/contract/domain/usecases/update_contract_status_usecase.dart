import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_entity.dart';
import 'package:ehtirafy_app/features/client/contract/domain/repositories/contract_repository.dart';

class UpdateContractStatusUseCase {
  final ContractRepository repository;

  UpdateContractStatusUseCase(this.repository);

  Future<Either<Failure, ContractEntity>> call({
    required String id,
    required String status,
    bool isPhotographer = false,
    String? noteText,
  }) async {
    return await repository.updateContractStatus(
      id,
      status,
      isPhotographer: isPhotographer,
      noteText: noteText,
    );
  }
}
