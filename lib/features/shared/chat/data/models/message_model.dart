import '../../domain/entities/message_entity.dart';

class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.senderId,
    required super.receiverId,
    required super.content,
    required super.timestamp,
    required super.isRead,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    final ts = json['timestamp'];
    return MessageModel(
      id: json['id']?.toString() ?? '',
      senderId: json['senderId']?.toString() ?? '',
      receiverId: json['receiverId']?.toString() ?? '',
      content: json['content']?.toString() ?? '',
      timestamp: ts is String ? (DateTime.tryParse(ts) ?? DateTime.now()) : DateTime.now(),
      isRead: json['isRead'] == true ||
          json['isRead'] == 1 ||
          json['isRead'] == '1' ||
          json['isRead'] == 'true',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'senderId': senderId,
      'receiverId': receiverId,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'isRead': isRead,
    };
  }
}
