import 'package:dio/dio.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import 'package:ehtirafy_app/core/error/exceptions.dart';

class ApiErrorHandler {
  static Failure handle(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return const NetworkFailure('Connection timeout');

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          if (statusCode != null) {
            if (statusCode == 400 || statusCode == 401 || statusCode == 403) {
              final data = error.response?.data;
              if (data is Map<String, dynamic>) {
                final message = data['message'] ?? 'Authentication failed';
                return ServerFailure(message.toString());
              }
              return const ServerFailure('Request failed');
            } else if (statusCode >= 500) {
              return const ServerFailure('Internal server error');
            }
          }
          return const ServerFailure('Received invalid status code');

        case DioExceptionType.cancel:
          return const NetworkFailure('Request cancelled');

        case DioExceptionType.connectionError:
          return const NetworkFailure('No internet connection');

        default:
          return const NetworkFailure('Unexpected network error');
      }
    } else if (error is ServerException) {
      return ServerFailure(error.message);
    } else if (error is CacheException) {
      return CacheFailure(error.message);
    } else {
      return const ServerFailure('Unexpected error occurred');
    }
  }
}
