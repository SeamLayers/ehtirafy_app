import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/domain/usecase.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import '../entities/bank_account_entity.dart';
import '../repositories/payment_repository.dart';

class GetBankAccountDetailsUseCase
    implements UseCase<BankAccountEntity, NoParams> {
  final PaymentRepository repository;

  GetBankAccountDetailsUseCase(this.repository);

  @override
  Future<Either<Failure, BankAccountEntity>> call(NoParams params) {
    return repository.getBankAccountDetails();
  }
}
