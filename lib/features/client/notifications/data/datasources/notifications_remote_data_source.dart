import 'package:ehtirafy_app/core/network/api_constants.dart';
import 'package:ehtirafy_app/core/network/dio_client.dart';
import 'package:ehtirafy_app/core/error/exceptions.dart';
import 'package:ehtirafy_app/features/client/notifications/data/models/notification_model.dart';

abstract class NotificationsRemoteDataSource {
  Future<List<NotificationModel>> getNotifications();
  Future<void> markAsRead(String id);
}

class NotificationsRemoteDataSourceImpl
    implements NotificationsRemoteDataSource {
  final DioClient dioClient;

  NotificationsRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<NotificationModel>> getNotifications() async {
    try {
      final response = await dioClient.get(ApiConstants.notifications);

      if (response.statusCode == 200) {
        final data = response.data;
        if (data['data'] != null && data['data'] is List) {
          return (data['data'] as List)
              .map((json) => NotificationModel.fromJson(_mapApiResponse(json)))
              .toList();
        }
        return [];
      } else {
        throw ServerException(
          response.data['message'] ?? 'فشل في جلب الإشعارات',
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> markAsRead(String id) async {
    try {
      final response = await dioClient.get(ApiConstants.readNotification(id));

      if (response.statusCode == 200) {
        return;
      } else {
        throw ServerException(
          response.data['message'] ?? 'فشل في تحديد الإشعار كمقروء',
        );
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  /// Maps API response fields to our model's expected format
  Map<String, dynamic> _mapApiResponse(Map<String, dynamic> json) {
    return {
      'id': json['id']?.toString() ?? '',
      'title': json['title'] ?? json['data']?['title'] ?? '',
      'body': json['body'] ?? json['data']?['body'] ?? '',
      'time': json['created_at'] ?? json['time'] ?? '',
      'isUnread': json['read_at'] == null,
      'type': json['type'] ?? 'general',
    };
  }
}
