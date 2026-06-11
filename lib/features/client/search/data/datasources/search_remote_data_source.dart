import 'package:ehtirafy_app/core/errors/exceptions.dart';
import 'package:ehtirafy_app/core/network/api_constants.dart';
import 'package:ehtirafy_app/core/network/dio_client.dart';
import 'package:ehtirafy_app/features/client/search/data/models/search_result_model.dart';

abstract class SearchRemoteDataSource {
  Future<List<SearchResultModel>> search(
    String query, {
    String type = 'freelancer',
  });
}

class SearchRemoteDataSourceImpl implements SearchRemoteDataSource {
  final DioClient dioClient;

  SearchRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<SearchResultModel>> search(
    String query, {
    String type = 'freelancer',
  }) async {
    try {
      final response = await dioClient.get(
        ApiConstants.search,
        queryParameters: {'key': query, 'type': type},
      );

      if (response.statusCode == 200) {
        final data = response.data;
        final rawData = (data is Map) ? data['data'] : null;
        if (rawData is List) {
          return rawData
              .whereType<Map>()
              .map((json) => SearchResultModel.fromJson(
                    Map<String, dynamic>.from(json),
                  ))
              .toList();
        }
      }
      return [];
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
