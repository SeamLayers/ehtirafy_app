import 'package:flutter/foundation.dart';
import 'package:ehtirafy_app/core/errors/exceptions.dart';
import 'package:ehtirafy_app/core/network/api_constants.dart';
import 'package:ehtirafy_app/core/network/dio_client.dart';
import 'package:ehtirafy_app/features/client/contract/data/models/contract_model.dart';
import 'package:ehtirafy_app/features/client/contract/data/models/contract_details_model.dart';

abstract class ContractRemoteDataSource {
  Future<ContractModel> createInitialContract(Map<String, dynamic> body);
  Future<ContractModel> updateContract(String id, Map<String, dynamic> body);
  Future<ContractModel> confirmPayment(String id);
  Future<List<ContractModel>> getContracts(Map<String, dynamic> params);
  Future<ContractDetailsModel> getContractDetails(String id);
}

class ContractRemoteDataSourceImpl implements ContractRemoteDataSource {
  final DioClient _dioClient;

  ContractRemoteDataSourceImpl(this._dioClient);

  @override
  Future<ContractModel> createInitialContract(Map<String, dynamic> body) async {
    final response = await _dioClient.post(
      ApiConstants.initialContract,
      data: body,
    );

    final data = response.data;
    if (data['status'] == 200 || data['success'] == true) {
      return ContractModel.fromJson(data['data']);
    } else {
      throw ServerException(data['message'] ?? 'فشل في إنشاء العقد');
    }
  }

  @override
  Future<ContractModel> confirmPayment(String id) async {
    // The confirm-payment endpoint doesn't exist on this API.
    // Instead, we update contr_cust_status to 'Paid' via the contract update endpoint.
    // This is the actual API pattern verified via testing.
    return updateContract(id, {
      '_method': 'PUT',
      'note_type': 'customer',
      'contr_cust_status': 'Paid',
      'note_text': 'تم تأكيد الدفع',
    });
  }

  @override
  Future<ContractModel> updateContract(
    String id,
    Map<String, dynamic> body,
  ) async {
    // Ensure _method is PUT
    final Map<String, dynamic> requestData = Map.from(body);
    requestData['_method'] = 'PUT';

    final response = await _dioClient.post(
      ApiConstants.updateContract(id),
      data: requestData,
    );

    final data = response.data;
    if (data['status'] == 200 || data['success'] == true) {
      if (data['data'] != null) {
        return ContractModel.fromJson(data['data']);
      }
      return ContractModel.fromJson(data['data'] ?? {});
    } else {
      throw ServerException(data['message'] ?? 'فشل في تحديث العقد');
    }
  }

  @override
  Future<List<ContractModel>> getContracts(Map<String, dynamic> params) async {
    debugPrint('🔍 ContractRemoteDataSource.getContracts - params: $params');
    debugPrint(
      '🔍 ContractRemoteDataSource.getContracts - URL: ${ApiConstants.contractsRelative}',
    );

    final response = await _dioClient.get(
      ApiConstants.contractsRelative,
      queryParameters: params,
    );

    final data = response.data;
    // Handle both status 200 and success: true
    if (data['status'] == 200 || data['success'] == true) {
      final dynamic responseData = data['data'];
      if (responseData is List) {
        return responseData.map((e) => ContractModel.fromJson(e)).toList();
      } else if (responseData == null) {
        return [];
      } else {
        // If data is not a list but success is true, maybe it's wrapped or unexpected format
        // For now, return empty list to avoid crash if not list
        return [];
      }
    } else {
      throw ServerException(data['message'] ?? 'فشل في جلب العقود');
    }
  }

  @override
  Future<ContractDetailsModel> getContractDetails(String id) async {
    final response = await _dioClient.get(ApiConstants.contractDetail(id));

    final data = response.data;
    if (data['status'] == 200 || data['success'] == true) {
      final responseData = data['data'];

      // Handle case where data might be a Map (Object) directly
      if (responseData is Map<String, dynamic>) {
        return ContractDetailsModel.fromJson(responseData);
      }
      // Handle legacy case where it might be a List (fallback)
      else if (responseData is List && responseData.isNotEmpty) {
        return ContractDetailsModel.fromJson(responseData.first);
      } else {
        // Try to parse empty map if structure allows, or throw specific error
        throw const ServerException('بيانات العقد غير صالحة');
      }
    } else {
      throw ServerException(data['message'] ?? 'فشل في جلب تفاصيل العقد');
    }
  }
}
