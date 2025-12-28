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
      id: json['id'] as String,
      title: json['title'] as String,
      body: json['body'] as String,
      time: json['time'] as String,
      isUnread: json['isUnread'] as bool,
      type: json['type'] as String,
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
