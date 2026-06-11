import '../../domain/entities/conversation_entity.dart';

class ConversationModel extends ConversationEntity {
  const ConversationModel({
    required super.id,
    required super.otherUserName,
    required super.otherUserImage,
    required super.lastMessage,
    required super.unreadCount,
    required super.lastMessageTime,
  });

  factory ConversationModel.fromJson(Map<String, dynamic> json) {
    return ConversationModel(
      id: json['id']?.toString() ?? '',
      otherUserName: json['otherUserName']?.toString() ?? '',
      otherUserImage: json['otherUserImage']?.toString() ?? '',
      lastMessage: json['lastMessage']?.toString() ?? '',
      unreadCount: json['unreadCount'] is int
          ? json['unreadCount']
          : int.tryParse(json['unreadCount']?.toString() ?? '') ?? 0,
      lastMessageTime:
          DateTime.tryParse(json['lastMessageTime']?.toString() ?? '') ??
              DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'otherUserName': otherUserName,
      'otherUserImage': otherUserImage,
      'lastMessage': lastMessage,
      'unreadCount': unreadCount,
      'lastMessageTime': lastMessageTime.toIso8601String(),
    };
  }
}
