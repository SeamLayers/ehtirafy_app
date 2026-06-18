import 'package:ehtirafy_app/core/network/api_constants.dart';
import 'package:ehtirafy_app/core/network/dio_client.dart';
import 'package:ehtirafy_app/core/errors/exceptions.dart';
import 'package:ehtirafy_app/features/client/freelancer/data/models/freelancer_model.dart';
import 'package:ehtirafy_app/features/client/freelancer/data/models/work_details_model.dart';
import 'package:ehtirafy_app/features/client/freelancer/data/models/advertisement_details_model.dart';

abstract class FreelancerRemoteDataSource {
  Future<FreelancerModel> getFreelancerProfile(String id);
  Future<String> getFreelancerPhone(String id);
  Future<WorkDetailsModel> getWorkDetails(String id);
  Future<AdvertisementDetailsModel> getAdvertisementDetails(String id);
}

class FreelancerRemoteDataSourceImpl implements FreelancerRemoteDataSource {
  final DioClient dioClient;

  FreelancerRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<FreelancerModel> getFreelancerProfile(String id) async {
    try {
      final response = await dioClient.get(ApiConstants.freelancerProfile(id));

      if (response.statusCode == 200) {
        final body = response.data;
        final data = (body is Map) ? body['data'] : null;
        if (data is! Map<String, dynamic>) {
          throw const ServerException('Invalid response format');
        }
        return FreelancerModel.fromJson(data);
      } else {
        final body = response.data;
        final message = (body is Map) ? body['message'] : null;
        throw ServerException(message?.toString() ?? 'Unknown error');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<String> getFreelancerPhone(String id) async {
    try {
      final response = await dioClient.get(ApiConstants.freelancerProfile(id));

      if (response.statusCode == 200) {
        final body = response.data;
        final data = (body is Map) ? body['data'] : null;
        if (data is! Map<String, dynamic>) {
          throw const ServerException('Invalid response format');
        }
        // Phone may arrive under several keys; absent/null → empty string.
        return (data['phone'] ?? data['mobile'] ?? data['phone_number'])
                ?.toString() ??
            '';
      } else {
        final body = response.data;
        final message = (body is Map) ? body['message'] : null;
        throw ServerException(message?.toString() ?? 'Unknown error');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<WorkDetailsModel> getWorkDetails(String id) async {
    try {
      final response = await dioClient.get(
        ApiConstants.portfolioItemDetails(id),
      );

      if (response.statusCode == 200) {
        final body = response.data;
        final data = (body is Map) ? body['data'] : null;
        if (data is! Map<String, dynamic>) {
          throw const ServerException('Invalid response format');
        }
        return WorkDetailsModel.fromJson(data);
      } else {
        final body = response.data;
        final message = (body is Map) ? body['message'] : null;
        throw ServerException(message?.toString() ?? 'Unknown error');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<AdvertisementDetailsModel> getAdvertisementDetails(String id) async {
    try {
      final response = await dioClient.get(
        ApiConstants.advertisementDetails(id),
      );

      if (response.statusCode == 200) {
        final body = response.data;
        final data = (body is Map) ? body['data'] : null;
        if (data is! Map<String, dynamic>) {
          throw const ServerException('Invalid response format');
        }
        return AdvertisementDetailsModel.fromJson(data);
      } else {
        final body = response.data;
        final message = (body is Map) ? body['message'] : null;
        throw ServerException(message?.toString() ?? 'Unknown error');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
