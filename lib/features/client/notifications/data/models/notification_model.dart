import 'package:ehtirafy_app/features/client/notifications/domain/entities/notification_entity.dart';

class NotificationModel extends NotificationEntity {
  const NotificationModel({
    required super.id,
    required super.title,
    required super.body,
    required super.time,
    required super.isUnread,
    required super.type,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      isUnread: json['isUnread'] == true ||
          json['isUnread'] == 1 ||
          json['isUnread']?.toString().toLowerCase() == 'true',
      type: json['type']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'body': body,
      'time': time,
      'isUnread': isUnread,
      'type': type,
    };
  }
}
