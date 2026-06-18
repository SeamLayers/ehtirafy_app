import 'package:ehtirafy_app/core/network/api_constants.dart';
import 'package:ehtirafy_app/core/network/dio_client.dart';
import 'package:ehtirafy_app/core/errors/exceptions.dart';
import '../models/city_model.dart';

abstract class CitiesRemoteDataSource {
  Future<List<CityModel>> getCities();
}

class CitiesRemoteDataSourceImpl implements CitiesRemoteDataSource {
  final DioClient dioClient;

  CitiesRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<CityModel>> getCities() async {
    try {
      final response = await dioClient.get(ApiConstants.cities);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && data['data'] is List) {
          return (data['data'] as List)
              .whereType<Map<String, dynamic>>()
              .map((json) => CityModel.fromJson(json))
              .toList();
        }
      }
      return [];
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
