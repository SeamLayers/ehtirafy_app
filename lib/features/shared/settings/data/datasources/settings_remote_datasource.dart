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
      if (response.statusCode == 200) {
        return StaticPageModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
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
      if (response.statusCode == 200) {
        return StaticPageModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<ContactInfoModel> getContactUs() async {
    try {
      final response = await dioClient.get(ApiConstants.contactUs);
      if (response.statusCode == 200) {
        return ContactInfoModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      rethrow;
    }
  }
}
