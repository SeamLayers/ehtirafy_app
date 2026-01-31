import '../models/login_model.dart';
import '../models/register_request_params.dart';
import '../models/register_response_model.dart';
import 'package:ehtirafy_app/core/network/dio_client.dart';
import 'package:ehtirafy_app/core/network/api_constants.dart';
import 'package:ehtirafy_app/core/network/base_response.dart';
import 'package:ehtirafy_app/core/error/exceptions.dart';
import 'package:dio/dio.dart';

abstract class AuthRemoteDataSource {
  Future<LoginModel> login({
    required String email,
    required String password,
    required String deviceToken,
  });
  Future<RegisterResponseModel> signup(RegisterRequestParams params);
  Future<String> forgotPassword(String email);
  Future<String> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  });
  Future<String> sendOtp({required String phone, required String countryCode});
  Future<void> logout();
  Future<String> verifyOtp({
    required String phone,
    required String countryCode,
    required String otp,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final DioClient _dioClient;

  AuthRemoteDataSourceImpl(this._dioClient);

  @override
  Future<LoginModel> login({
    required String email,
    required String password,
    required String deviceToken,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.login,
        data: FormData.fromMap({
          'email': email,
          'password': password,
          'device_token': deviceToken,
        }),
      );

      final baseResponse = BaseResponse<LoginModel>.fromJson(
        response.data,
        (json) => LoginModel.fromJson(json as Map<String, dynamic>),
      );

      if (baseResponse.data != null) {
        return baseResponse.data!;
      } else {
        if (baseResponse.status == 200) {
          throw const ServerException('الحالة ناجحة لكن لا توجد بيانات');
        }
        throw ServerException(baseResponse.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<RegisterResponseModel> signup(RegisterRequestParams params) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.register,
        data: params.toJson(),
      );

      final baseResponse = BaseResponse<RegisterResponseModel>.fromJson(
        response.data,
        (json) => RegisterResponseModel.fromJson(json as Map<String, dynamic>),
      );

      if (baseResponse.data != null) {
        return baseResponse.data!;
      } else {
        if (baseResponse.status == 200) {
          throw const ServerException('الحالة ناجحة لكن لا توجد بيانات');
        }
        throw ServerException(baseResponse.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> forgotPassword(String email) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.forgotPassword,
        data: FormData.fromMap({'email': email}),
      );

      final baseResponse = BaseResponse<String>.fromJson(
        response.data,
        (json) => json
            .toString(),
      );

      if (baseResponse.data != null) {
        return baseResponse.data!;
      }
      return baseResponse.message;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> resetPassword({
    required String email,
    required String otp,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.resetPassword,
        data: FormData.fromMap({
          'email': email,
          'otp': otp,
          'password': password,
          'password_confirmation': passwordConfirmation,
        }),
      );

      final baseResponse = BaseResponse<String>.fromJson(
        response.data,
        (json) => json.toString(),
      );

      if (baseResponse.status == 200) {
        return baseResponse.message;
      } else {
        throw ServerException(baseResponse.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> sendOtp({
    required String phone,
    required String countryCode,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.sendOtp,
        data: FormData.fromMap({'phone': phone, 'country_code': countryCode}),
      );

      print('Sent OTP Response Data: ${response.data}');

      // Handle response with "success": true
      if (response.data is Map<String, dynamic>) {
        final json = response.data as Map<String, dynamic>;
        if (json['success'] == true) {
           final data = json['data'];
           if (data is Map<String, dynamic>) {
             return data['otp']?.toString() ?? data['code']?.toString() ?? '';
           }
           return data?.toString() ?? '';
        }
      }

      final baseResponse = BaseResponse<String>.fromJson(response.data, (json) {
        if (json is Map<String, dynamic>) {
          return json['code']?.toString() ??
              json['otp']?.toString() ??
              json.toString();
        }
        return json.toString();
      });

      if (baseResponse.status == 200) {
        final otp = baseResponse.data ?? baseResponse.message;
        print('Parsed OTP: $otp');
        return otp;
      } else {
        throw ServerException(baseResponse.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> logout() async {
    try {
      final response = await _dioClient.post(ApiConstants.logout);

      final baseResponse = BaseResponse<void>.fromJson(response.data, (_) {});

      if (baseResponse.status != 200) {
        throw ServerException(baseResponse.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<String> verifyOtp({
    required String phone,
    required String countryCode,
    required String otp,
  }) async {
    try {
      final response = await _dioClient.post(
        ApiConstants.verifyOtp,
        data: FormData.fromMap({
          'phone': phone,
          'country_code': countryCode,
          'otp': otp,
        }),
      );

      final baseResponse = BaseResponse<String>.fromJson(
        response.data,
        (json) => json.toString(),
      );

      if (baseResponse.status == 200) {
        return baseResponse.message;
      } else {
        throw ServerException(baseResponse.message);
      }
    } catch (e) {
      rethrow;
    }
  }
}
