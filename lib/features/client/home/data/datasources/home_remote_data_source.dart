import 'package:ehtirafy_app/core/network/api_constants.dart';
import 'package:ehtirafy_app/core/network/dio_client.dart';
import 'package:ehtirafy_app/features/client/home/data/models/photographer_model.dart';
import 'package:ehtirafy_app/features/client/home/data/models/category_model.dart';
import 'package:ehtirafy_app/features/client/home/data/models/app_statistics_model.dart';
import 'package:ehtirafy_app/core/error/exceptions.dart';

abstract class HomeRemoteDataSource {
  Future<List<PhotographerModel>> getFeaturedPhotographers();
  Future<List<PhotographerModel>> getAllFreelancers();
  Future<List<CategoryModel>> getCategories();
  Future<AppStatisticsModel> getAppStatistics();
  Future<List<PhotographerModel>> getAdvertisementsByCategory(
    String categoryId,
  );
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  final DioClient dioClient;

  HomeRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<PhotographerModel>> getFeaturedPhotographers() async {
    try {
      final response = await dioClient.get(ApiConstants.bestFreelancers);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['data'] != null && data['data'] is List) {
          // Return all best freelancers, including those without advertisement
          // The model handles null advertisements gracefully
          return (data['data'] as List)
              .map((json) => PhotographerModel.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PhotographerModel>> getAllFreelancers() async {
    try {
      final response = await dioClient.get(ApiConstants.bestFreelancers);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['data'] != null && data['data'] is List) {
          // Return ALL entries, including those without advertisement
          return (data['data'] as List)
              .map((json) => PhotographerModel.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    try {
      final response = await dioClient.get(ApiConstants.categories);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['data'] != null && data['data'] is List) {
          return (data['data'] as List)
              .map((json) => CategoryModel.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      // Return empty list on error, or rethrow if you want to handle it in repository
      rethrow;
    }
  }

  @override
  Future<AppStatisticsModel> getAppStatistics() async {
    try {
      final response = await dioClient.get('/api/v1/app/statistics');

      // Check both HTTP status and API status
      final data = response.data;
      if (response.statusCode == 200 && data != null && data['data'] != null) {
        return AppStatisticsModel.fromJson(data['data']);
      } else {
        throw ServerException(data?['message'] ?? 'Unknown error');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<PhotographerModel>> getAdvertisementsByCategory(
    String categoryId,
  ) async {
    try {
      final response = await dioClient.get(
        ApiConstants.advertisementsByCategory(categoryId),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['data'] != null && data['data'] is List) {
          return (data['data'] as List)
              .where((json) => json['advertisement'] != null)
              .map((json) => PhotographerModel.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
