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

  @override
  Future<BankAccountModel> getBankAccountDetails() async {
    try {
      final response = await _dioClient.get(ApiConstants.bankAccountDetails);
      final data = response.data['data'] ?? response.data;
      return BankAccountModel.fromJson(data);
    } on DioException catch (e) {
      throw ServerException(
        e.response?.data['message'] ?? 'فشل في جلب تفاصيل الحساب البنكي',
      );
    }
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
