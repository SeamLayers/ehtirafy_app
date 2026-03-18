import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import 'package:ehtirafy_app/features/client/contract/domain/entities/contract_entity.dart';
import 'package:ehtirafy_app/features/client/contract/domain/repositories/contract_repository.dart';

class ConfirmPaymentUseCase {
  final ContractRepository repository;

  ConfirmPaymentUseCase(this.repository);

  Future<Either<Failure, ContractEntity>> call(String id) async {
    return await repository.confirmPayment(id);
  }
}
