import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_details_entity.dart';
import 'package:ehtirafy_app/features/client/contract/domain/repositories/contract_repository.dart';

class GetContractDetailsUseCase {
  final ContractRepository repository;

  GetContractDetailsUseCase(this.repository);

  Future<Either<Failure, ContractDetailsEntity>> call(String id) async {
    return await repository.getContractDetails(id);
  }
}
