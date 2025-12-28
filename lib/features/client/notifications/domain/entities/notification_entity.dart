import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String title;
  final String body;
  final String time;
  final bool isUnread;
  final String type;

  const NotificationEntity({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.isUnread,
    required this.type,
  });

  @override
  List<Object?> get props => [id, title, body, time, isUnread, type];
}
