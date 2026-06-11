import '../../../../../core/network/api_constants.dart';
import '../../../../../core/network/dio_client.dart';
import '../models/contact_info_model.dart';
import '../models/static_page_model.dart';

abstract class SettingsRemoteDataSource {
  Future<StaticPageModel> getPrivacyPolicy({String lang = 'ar'});
  Future<StaticPageModel> getTermsConditions({String lang = 'ar'});
  Future<ContactInfoModel> getContactUs();
}

class SettingsRemoteDataSourceImpl implements SettingsRemoteDataSource {
  final DioClient dioClient;

  SettingsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<StaticPageModel> getPrivacyPolicy({String lang = 'ar'}) async {
    try {
      final response = await dioClient.get(
        ApiConstants.privacyPolicy,
        queryParameters: {'lang': lang},
      );
      final body = response.data;
      if (response.statusCode == 200) {
        final data = (body is Map) ? body['data'] : null;
        if (data is! Map<String, dynamic>) {
          throw Exception('Invalid privacy policy response');
        }
        return StaticPageModel.fromJson(data);
      } else {
        throw Exception((body is Map) ? body['message'] : null);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<StaticPageModel> getTermsConditions({String lang = 'ar'}) async {
    try {
      final response = await dioClient.get(
        ApiConstants.termsConditions,
        queryParameters: {'lang': lang},
      );
      final body = response.data;
      if (response.statusCode == 200) {
        final data = (body is Map) ? body['data'] : null;
        if (data is! Map<String, dynamic>) {
          throw Exception('Invalid terms response');
        }
        return StaticPageModel.fromJson(data);
      } else {
        throw Exception((body is Map) ? body['message'] : null);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ContactInfoModel> getContactUs() async {
    try {
      final response = await dioClient.get(ApiConstants.contactUs);
      final body = response.data;
      if (response.statusCode == 200) {
        final data = (body is Map) ? body['data'] : null;
        if (data is! Map<String, dynamic>) {
          throw Exception('Invalid contact-us response');
        }
        return ContactInfoModel.fromJson(data);
      } else {
        throw Exception((body is Map) ? body['message'] : null);
      }
    } catch (e) {
      rethrow;
    }
  }
}
