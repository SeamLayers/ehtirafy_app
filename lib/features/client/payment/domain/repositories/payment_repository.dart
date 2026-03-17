import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import '../entities/bank_account_entity.dart';
import '../entities/payment_proof_entity.dart';

abstract class PaymentRepository {
  /// Fetch bank account details for payments
  Future<Either<Failure, BankAccountEntity>> getBankAccountDetails();

  /// Submit payment proof and update contract status
  /// [contractId]: The contract ID to submit payment proof for
  /// [senderName]: Name of the person making the transfer
  /// [transferDate]: Date of the bank transfer
  /// [proofFilePath]: Path to the proof file (image or PDF)
  /// [transferReference]: Optional transfer reference/receipt number
  /// [notes]: Optional additional notes
  Future<Either<Failure, void>> submitPaymentProof({
    required String contractId,
    required String senderName,
    required DateTime transferDate,
    required String proofFilePath,
    String? transferReference,
    String? notes,
  });
}
