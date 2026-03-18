import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:ehtirafy_app/core/domain/usecase.dart';
import 'package:ehtirafy_app/core/errors/failures.dart';
import '../repositories/payment_repository.dart';

class SubmitPaymentProofUseCase implements UseCase<void, SubmitPaymentProofParams> {
  final PaymentRepository repository;

  SubmitPaymentProofUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(SubmitPaymentProofParams params) {
    return repository.submitPaymentProof(
      contractId: params.contractId,
      senderName: params.senderName,
      transferDate: params.transferDate,
      proofFilePath: params.proofFilePath,
      transferReference: params.transferReference,
      notes: params.notes,
    );
  }
}

class SubmitPaymentProofParams extends Equatable {
  final String contractId;
  final String senderName;
  final DateTime transferDate;
  final String proofFilePath;
  final String? transferReference;
  final String? notes;

  const SubmitPaymentProofParams({
    required this.contractId,
    required this.senderName,
    required this.transferDate,
    required this.proofFilePath,
    this.transferReference,
    this.notes,
  });

  @override
  List<Object?> get props => [
        contractId,
        senderName,
        transferDate,
        proofFilePath,
        transferReference,
        notes,
      ];
}
