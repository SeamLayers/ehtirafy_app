import 'package:dio/dio.dart';
import 'package:ehtirafy_app/core/errors/exceptions.dart';
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
        'adv_id': contractId,
        'note': notes ?? 'Payment from $senderName on ${transferDate.toIso8601String()}',
      });

      // Add proof file (receipt image)
      if (proofFilePath.isNotEmpty) {
        formData.files.add(
          MapEntry(
            'images',
            await MultipartFile.fromFile(
              proofFilePath,
              filename: 'payment_proof_${DateTime.now().millisecondsSinceEpoch}',
            ),
          ),
        );
      }

      final response = await _dioClient.post(
        ApiConstants.submitPaymentProof,
        data: formData,
      );

      final data = response.data;
      if (data is Map) {
        if (data['success'] != true && data['status'] != 200) {
          throw ServerException(
            (data['message'] as String?) ?? 'فشل في إرسال إثبات الدفع',
          );
        }
      } else {
        throw const ServerException('فشل في إرسال إثبات الدفع');
      }
    } on DioException catch (e) {
      final body = e.response?.data;
      final msg = body is Map ? (body['message'] as String?) : null;
      throw ServerException(msg ?? 'فشل في إرسال إثبات الدفع');
    }
  }
}
