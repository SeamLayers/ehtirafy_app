import 'package:flutter/foundation.dart';
import 'package:ehtirafy_app/core/error/exceptions.dart';
import 'package:ehtirafy_app/core/network/api_constants.dart';
import 'package:ehtirafy_app/core/network/dio_client.dart';
import 'package:ehtirafy_app/features/client/contract/data/models/contract_model.dart';
import 'package:ehtirafy_app/features/client/contract/data/models/contract_details_model.dart';

abstract class ContractRemoteDataSource {
  Future<ContractModel> createInitialContract(Map<String, dynamic> body);
  Future<ContractModel> updateContract(String id, Map<String, dynamic> body);
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
    if (data['status'] == 200) {
      return ContractModel.fromJson(data['data']);
    } else {
      throw ServerException(data['message'] ?? 'فشل في إنشاء العقد');
    }
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
    if (data['status'] == 200) {
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
    if (data['status'] == 200) {
      // The response data is a list [{}], we take the first element
      final List list = data['data'];
      if (list.isNotEmpty) {
        return ContractDetailsModel.fromJson(list.first);
      } else {
        throw const ServerException('العقد غير موجود');
      }
    } else {
      throw ServerException(data['message'] ?? 'فشل في جلب تفاصيل العقد');
    }
  }
}
