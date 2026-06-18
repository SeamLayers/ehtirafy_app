import 'package:ehtirafy_app/core/network/api_constants.dart';
import 'package:ehtirafy_app/core/network/dio_client.dart';
import 'package:ehtirafy_app/features/client/home/data/models/photographer_model.dart';
import 'package:ehtirafy_app/features/client/home/data/models/category_model.dart';
import 'package:ehtirafy_app/features/client/home/data/models/app_statistics_model.dart';
import 'package:ehtirafy_app/core/errors/exceptions.dart';

abstract class HomeRemoteDataSource {
  Future<List<PhotographerModel>> getFeaturedPhotographers();
  Future<List<PhotographerModel>> getAllFreelancers();

  /// All published advertisements (the home "All" tab feed). Each ad carries a
  /// `city` field used for the client-side region filter.
  Future<List<PhotographerModel>> getAllAdvertisements();
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
        if (data is Map && data['data'] != null && data['data'] is List) {
          // Return all best freelancers, including those without advertisement
          // The model handles null advertisements gracefully
          return (data['data'] as List)
              .whereType<Map<String, dynamic>>()
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
      final response = await dioClient.get(ApiConstants.allFreelancersData);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['data'] != null && data['data'] is List) {
          // Return ALL entries, including those without advertisement
          return (data['data'] as List)
              .whereType<Map<String, dynamic>>()
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
  Future<List<PhotographerModel>> getAllAdvertisements() async {
    try {
      final response = await dioClient.get(
        ApiConstants.advertisements,
        queryParameters: const {'user_type': 'customer'},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['data'] != null && data['data'] is List) {
          return (data['data'] as List)
              .whereType<Map<String, dynamic>>()
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
        if (data is Map && data['data'] != null && data['data'] is List) {
          return (data['data'] as List)
              .whereType<Map<String, dynamic>>()
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
      final response = await dioClient.get(ApiConstants.appStatistics);

      // Check both HTTP status and API status
      final data = response.data;
      if (response.statusCode == 200 &&
          data is Map &&
          data['data'] != null) {
        final stats = data['data'];
        if (stats is Map<String, dynamic>) {
          return AppStatisticsModel.fromJson(stats);
        } else {
          throw const ServerException('Invalid statistics payload');
        }
      } else {
        throw ServerException(
          (data is Map ? data['message'] : null) ?? 'Unknown error',
        );
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
        if (data is Map && data['data'] != null && data['data'] is List) {
          return (data['data'] as List)
              .whereType<Map<String, dynamic>>()
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
