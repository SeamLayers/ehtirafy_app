import 'package:ehtirafy_app/core/network/api_constants.dart';
import 'package:ehtirafy_app/core/network/dio_client.dart';
import 'package:ehtirafy_app/core/error/exceptions.dart';
import 'package:ehtirafy_app/features/client/freelancer/data/models/freelancer_model.dart';
import 'package:ehtirafy_app/features/client/freelancer/data/models/work_details_model.dart';
import 'package:ehtirafy_app/features/client/freelancer/data/models/advertisement_details_model.dart';

abstract class FreelancerRemoteDataSource {
  Future<FreelancerModel> getFreelancerProfile(String id);
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
        return FreelancerModel.fromJson(response.data['data']);
      } else {
        throw ServerException(response.data['message'] ?? 'Unknown error');
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
        return WorkDetailsModel.fromJson(response.data['data']);
      } else {
        throw ServerException(response.data['message'] ?? 'Unknown error');
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
        return AdvertisementDetailsModel.fromJson(response.data['data']);
      } else {
        throw ServerException(response.data['message'] ?? 'Unknown error');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
