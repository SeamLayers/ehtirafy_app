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
      id: json['id'],
      otherUserName: json['otherUserName'],
      otherUserImage: json['otherUserImage'],
      lastMessage: json['lastMessage'],
      unreadCount: json['unreadCount'],
      lastMessageTime: DateTime.parse(json['lastMessageTime']),
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
