import '../models/login_model.dart';
import '../models/register_request_params.dart';
import '../models/register_response_model.dart';
import 'package:ehtirafy_app/core/network/dio_client.dart';
import 'package:ehtirafy_app/core/network/api_constants.dart';
import 'package:ehtirafy_app/core/network/base_response.dart';
import 'package:ehtirafy_app/core/errors/exceptions.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

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
  Future<void> deleteAccount(String userId);
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

      final raw = response.data;
      if (raw is! Map<String, dynamic>) {
        throw const ServerException('استجابة غير متوقعة من الخادم');
      }

      final baseResponse = BaseResponse<LoginModel>.fromJson(
        raw,
        (json) {
          if (json is! Map<String, dynamic>) {
            throw const ServerException('استجابة غير صالحة');
          }
          return LoginModel.fromJson(json);
        },
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

      final raw = response.data;
      if (raw is! Map<String, dynamic>) {
        throw const ServerException('استجابة غير متوقعة من الخادم');
      }

      final baseResponse = BaseResponse<RegisterResponseModel>.fromJson(
        raw,
        (json) {
          if (json is! Map<String, dynamic>) {
            throw const ServerException('استجابة غير صالحة');
          }
          return RegisterResponseModel.fromJson(json);
        },
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

      final raw = response.data;
      if (raw is! Map<String, dynamic>) {
        throw const ServerException('استجابة غير متوقعة من الخادم');
      }

      final baseResponse = BaseResponse<String>.fromJson(
        raw,
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

      final raw = response.data;
      if (raw is! Map<String, dynamic>) {
        throw const ServerException('استجابة غير متوقعة من الخادم');
      }

      final baseResponse = BaseResponse<String>.fromJson(
        raw,
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

      debugPrint('Sent OTP Response Data: ${response.data}');

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

      final raw = response.data;
      if (raw is! Map<String, dynamic>) {
        throw const ServerException('استجابة غير متوقعة من الخادم');
      }

      final baseResponse = BaseResponse<String>.fromJson(raw, (json) {
        if (json is Map<String, dynamic>) {
          return json['code']?.toString() ??
              json['otp']?.toString() ??
              json.toString();
        }
        return json.toString();
      });

      if (baseResponse.status == 200) {
        final otp = baseResponse.data ?? baseResponse.message;
        debugPrint('Parsed OTP: $otp');
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

      final raw = response.data;
      // A 204 / empty body is a common successful logout response.
      if (raw is! Map<String, dynamic>) {
        return;
      }

      final baseResponse = BaseResponse<void>.fromJson(raw, (_) {});

      if (baseResponse.status != 200) {
        throw ServerException(baseResponse.message);
      }
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteAccount(String userId) async {
    try {
      final response = await _dioClient.delete(ApiConstants.deleteAccount(userId));

      final raw = response.data;
      // A 204 / empty body is a common successful delete response.
      if (raw is! Map<String, dynamic>) {
        return;
      }

      final baseResponse = BaseResponse<void>.fromJson(raw, (_) {});

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

      final raw = response.data;
      if (raw is! Map<String, dynamic>) {
        throw const ServerException('استجابة غير متوقعة من الخادم');
      }

      final baseResponse = BaseResponse<String>.fromJson(
        raw,
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
