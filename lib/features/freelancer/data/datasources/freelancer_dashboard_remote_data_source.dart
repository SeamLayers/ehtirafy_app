import 'package:ehtirafy_app/core/network/api_constants.dart';
import 'package:ehtirafy_app/core/network/dio_client.dart';
import 'package:flutter/foundation.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/freelancer_statistics_model.dart';
import '../models/freelancer_last_contract_model.dart';

abstract class FreelancerDashboardRemoteDataSource {
  Future<FreelancerStatisticsModel> getStatistics(int freelancerId);
  Future<List<FreelancerLastContractModel>> getLastContracts(int freelancerId);
}

class FreelancerDashboardRemoteDataSourceImpl
    implements FreelancerDashboardRemoteDataSource {
  final DioClient dioClient;

  FreelancerDashboardRemoteDataSourceImpl(this.dioClient);

  @override
  Future<FreelancerStatisticsModel> getStatistics(int freelancerId) async {
    try {
      final response = await dioClient.get(
        ApiConstants.freelancerStatistics(freelancerId.toString()),
      );
      debugPrint('DEBUG: Statistics Response Data: ${response.data}');
      final body = response.data;
      if (body is Map && body['status'] == 'success') {
        final data = body['data'];
        if (data is Map) {
          return FreelancerStatisticsModel.fromJson(
            Map<String, dynamic>.from(data),
          );
        } else {
          throw const ServerException('فشل في جلب الإحصائيات');
        }
      } else {
        throw ServerException(
          (body is Map ? body['message'] : null) ?? 'فشل في جلب الإحصائيات',
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<FreelancerLastContractModel>> getLastContracts(
    int freelancerId,
  ) async {
    try {
      final response = await dioClient.get(
        ApiConstants.freelancerLastContracts(freelancerId.toString()),
      );
      debugPrint(
        'DEBUG: Last Contracts Response Data: ${response.data}',
      );
      final body = response.data;
      if (body is Map && body['status'] == 'success') {
        final raw = body['data'];
        final List<dynamic> data = raw is List ? raw : const [];
        return data
            .whereType<Map>()
            .map(
              (e) => FreelancerLastContractModel.fromJson(
                Map<String, dynamic>.from(e),
              ),
            )
            .toList();
      } else {
        throw ServerException(
          (body is Map ? body['message'] : null) ?? 'فشل في جلب آخر العقود',
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
