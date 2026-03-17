import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/exceptions.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import '../../domain/entities/bank_account_entity.dart';
import '../../domain/repositories/payment_repository.dart';
import '../datasources/payment_remote_data_source.dart';

class PaymentRepositoryImpl implements PaymentRepository {
  final PaymentRemoteDataSource remoteDataSource;

  PaymentRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, BankAccountEntity>> getBankAccountDetails() async {
    try {
      final bankAccount = await remoteDataSource.getBankAccountDetails();
      return Right(bankAccount);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(
        ServerFailure('فشل في جلب تفاصيل الحساب البنكي'),
      );
    }
  }

  @override
  Future<Either<Failure, void>> submitPaymentProof({
    required String contractId,
    required String senderName,
    required DateTime transferDate,
    required String proofFilePath,
    String? transferReference,
    String? notes,
  }) async {
    try {
      await remoteDataSource.submitPaymentProof(
        contractId: contractId,
        senderName: senderName,
        transferDate: transferDate,
        proofFilePath: proofFilePath,
        transferReference: transferReference,
        notes: notes,
      );
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    } catch (e) {
      return const Left(
        ServerFailure('فشل في إرسال إثبات الدفع'),
      );
    }
  }
}
