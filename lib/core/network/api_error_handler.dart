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
          return const NetworkFailure('انتهت مهلة الاتصال');

        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          final data = error.response?.data;

          // Extract message from response for any status code
          if (data is Map<String, dynamic> && data['message'] != null) {
            return ServerFailure(data['message'].toString());
          }

          if (statusCode != null) {
            if (statusCode >= 400 && statusCode < 500) {
              // All client errors (400, 401, 403, 404, 409, etc.)
              return const ServerFailure('فشل في الطلب');
            } else if (statusCode >= 500) {
              return const ServerFailure('خطأ في الخادم الداخلي');
            }
          }
          return const ServerFailure('تم استلام رمز حالة غير صالح');

        case DioExceptionType.cancel:
          return const NetworkFailure('تم إلغاء الطلب');

        case DioExceptionType.connectionError:
          return const NetworkFailure('لا يوجد اتصال بالإنترنت');

        default:
          return const NetworkFailure('خطأ غير متوقع في الشبكة');
      }
    } else if (error is ServerException) {
      return ServerFailure(error.message);
    } else if (error is CacheException) {
      return CacheFailure(error.message);
    } else {
      return const ServerFailure('حدث خطأ غير متوقع');
    }
  }
}
