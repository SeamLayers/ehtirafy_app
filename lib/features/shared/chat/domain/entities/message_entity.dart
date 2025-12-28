import 'package:equatable/equatable.dart';

class MessageEntity extends Equatable {
  final String id;
  final String senderId;
  final String receiverId;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  const MessageEntity({
    required this.id,
    required this.senderId,
    required this.receiverId,
    required this.content,
    required this.timestamp,
    required this.isRead,
  });

  @override
  List<Object?> get props => [
    id,
    senderId,
    receiverId,
    content,
    timestamp,
    isRead,
  ];
}
