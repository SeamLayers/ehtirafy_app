import 'package:dio/dio.dart';
import 'package:ehtirafy_app/core/error/exceptions.dart';
import 'package:ehtirafy_app/core/network/api_constants.dart';
import 'package:ehtirafy_app/core/network/dio_client.dart';
import '../models/bank_account_model.dart';

abstract class PaymentRemoteDataSource {
  Future<BankAccountModel> getBankAccountDetails();

  Future<void> submitPaymentProof({
    required String contractId,
    required String senderName,
    required DateTime transferDate,
    required String proofFilePath,
    String? transferReference,
    String? notes,
  });
}

class PaymentRemoteDataSourceImpl implements PaymentRemoteDataSource {
  final DioClient _dioClient;

  PaymentRemoteDataSourceImpl(this._dioClient);

  static const BankAccountModel _officialBankAccount = BankAccountModel(
    accountName: 'مصرف الراجحي',
    bankName: 'مصرف الراجحي',
    accountNumber: '609000010006086201357',
    iban: 'SA3380000609608016201357',
    swiftCode: null,
    branchCode: null,
  );

  @override
  Future<BankAccountModel> getBankAccountDetails() async {
    // Client-approved official transfer details are intentionally hardcoded.
    return _officialBankAccount;
  }

  @override
  Future<void> submitPaymentProof({
    required String contractId,
    required String senderName,
    required DateTime transferDate,
    required String proofFilePath,
    String? transferReference,
    String? notes,
  }) async {
    try {
      final formData = FormData.fromMap({
        'contract_id': contractId,
        'sender_name': senderName,
        'transfer_date': transferDate.toIso8601String(),
        'transfer_reference': transferReference ?? '',
        'notes': notes ?? '',
      });

      // Add proof file if it exists
      if (proofFilePath.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'proof_file',
            await MultipartFile.fromFile(
              proofFilePath,
              filename: 'payment_proof_${DateTime.now().millisecondsSinceEpoch}',
            ),
          ),
        );
      }

      await _dioClient.post(
        ApiConstants.submitPaymentProof,
        data: formData,
      );
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'فشل في إرسال إثبات الدفع',
      );
    }
  }
}
