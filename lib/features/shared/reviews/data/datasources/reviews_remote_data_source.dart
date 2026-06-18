import 'package:dio/dio.dart';
import 'package:ehtirafy_app/core/network/api_constants.dart';
import 'package:ehtirafy_app/core/network/dio_client.dart';
import 'package:ehtirafy_app/core/errors/exceptions.dart';
import 'package:ehtirafy_app/features/shared/reviews/data/models/review_model.dart';

abstract class ReviewsRemoteDataSource {
  Future<void> addRate({
    required String ratedUserId,
    required String advertisementId,
    required double rating,
    required String comment,
  });

  Future<List<ReviewModel>> getUserRates({required String userId});
}

class ReviewsRemoteDataSourceImpl implements ReviewsRemoteDataSource {
  final DioClient dioClient;

  ReviewsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<void> addRate({
    required String ratedUserId,
    required String advertisementId,
    required double rating,
    required String comment,
  }) async {
    try {
      final formData = FormData.fromMap({
        'advertisement_id': advertisementId,
        'rate': rating.toInt(),
        'description': comment,
      });

      final response = await dioClient.post(
        ApiConstants.addRate,
        data: formData,
      );

      final data = response.data;
      if (data is Map<String, dynamic> && data['success'] != true) {
        throw ServerException(data['message'] ?? 'خطأ غير معروف');
      }
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data['message'] != null) {
        throw ServerException(data['message']);
      }
      throw ServerException(e.message ?? 'خطأ في الاتصال');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<ReviewModel>> getUserRates({required String userId}) async {
    try {
      final response = await dioClient.get(ApiConstants.userRates(userId));

      if (response.statusCode == 200) {
        final body = response.data;
        final data = (body is Map) ? body['data'] : null;
        // API returns { count: N, ratings: [...] }
        if (data is Map) {
          final ratings = data['ratings'];
          if (ratings is List) {
            return ratings
                .whereType<Map>()
                .map((e) => ReviewModel.fromJson(Map<String, dynamic>.from(e)))
                .toList();
          }
        }
        // Fallback if data is directly a list
        if (data is List) {
          return data
              .whereType<Map>()
              .map((e) => ReviewModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }
        return [];
      } else {
        final body = response.data;
        final msg = (body is Map) ? body['message'] : null;
        throw ServerException(msg ?? 'خطأ غير معروف');
      }
    } on ServerException {
      rethrow;
    } on DioException catch (e) {
      final data = e.response?.data;
      if (data is Map<String, dynamic> && data['message'] != null) {
        throw ServerException(data['message']);
      }
      throw ServerException(e.message ?? 'خطأ في الاتصال');
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
