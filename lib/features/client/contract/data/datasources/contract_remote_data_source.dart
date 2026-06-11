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
    if (data is Map && (data['status'] == 200 || data['success'] == true)) {
      final d = data['data'];
      if (d is Map<String, dynamic>) {
        return ContractModel.fromJson(d);
      }
      throw const ServerException('بيانات العقد غير صالحة');
    } else {
      throw ServerException(_extractError(data) ?? 'فشل في إنشاء العقد');
    }
  }

  /// Build a human-readable message from a validation error response.
  /// Laravel returns `{ "message": "...", "errors": { field: [msg, ...] } }`,
  /// so surface the first field error instead of the generic message.
  String? _extractError(dynamic data) {
    if (data is! Map) return null;
    final errors = data['errors'];
    if (errors is Map && errors.isNotEmpty) {
      final first = errors.values.first;
      if (first is List && first.isNotEmpty) return first.first?.toString();
      return first?.toString();
    }
    return data['message']?.toString();
  }

  @override
  Future<ContractModel> confirmPayment(String id) async {
    // Legacy method kept for backward compatibility with old UI actions.
    // Backend now uses only contract_status.
    return updateContract(id, {
      '_method': 'PUT',
      'user_type': 'customer',
      'note_type': 'customer',
      'contract_status': 'InProgress',
      'note_text': 'تم تحديث حالة العقد',
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
    if (data is Map && (data['status'] == 200 || data['success'] == true)) {
      final d = data['data'];
      if (d is Map<String, dynamic>) {
        return ContractModel.fromJson(d);
      }
      return ContractModel.fromJson(const <String, dynamic>{});
    } else {
      throw ServerException(
        (data is Map ? data['message'] : null) ?? 'فشل في تحديث العقد',
      );
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
    if (data is Map && (data['status'] == 200 || data['success'] == true)) {
      final dynamic responseData = data['data'];
      if (responseData is List) {
        return responseData
            .whereType<Map<String, dynamic>>()
            .map((e) => ContractModel.fromJson(e))
            .toList();
      } else if (responseData == null) {
        return [];
      } else {
        // If data is not a list but success is true, maybe it's wrapped or unexpected format
        // For now, return empty list to avoid crash if not list
        return [];
      }
    } else {
      throw ServerException(
        (data is Map ? data['message'] : null) ?? 'فشل في جلب العقود',
      );
    }
  }

  @override
  Future<ContractDetailsModel> getContractDetails(String id) async {
    final response = await _dioClient.get(ApiConstants.contractDetail(id));

    final data = response.data;
    if (data is Map && (data['status'] == 200 || data['success'] == true)) {
      final responseData = data['data'];

      // Handle case where data might be a Map (Object) directly
      if (responseData is Map<String, dynamic>) {
        return ContractDetailsModel.fromJson(responseData);
      }
      // Handle legacy case where it might be a List (fallback)
      else if (responseData is List && responseData.isNotEmpty) {
        final first = responseData.first;
        if (first is Map<String, dynamic>) {
          return ContractDetailsModel.fromJson(first);
        }
        // Try to parse empty map if structure allows, or throw specific error
        throw const ServerException('بيانات العقد غير صالحة');
      } else {
        // Try to parse empty map if structure allows, or throw specific error
        throw const ServerException('بيانات العقد غير صالحة');
      }
    } else {
      throw ServerException(
        (data is Map ? data['message'] : null) ?? 'فشل في جلب تفاصيل العقد',
      );
    }
  }
}
