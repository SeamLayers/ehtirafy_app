import 'package:equatable/equatable.dart';

class ConversationEntity extends Equatable {
  final String id;
  final String otherUserName;
  final String otherUserImage;
  final String lastMessage;
  final int unreadCount;
  final DateTime lastMessageTime;

  const ConversationEntity({
    required this.id,
    required this.otherUserName,
    required this.otherUserImage,
    required this.lastMessage,
    required this.unreadCount,
    required this.lastMessageTime,
  });

  @override
  List<Object?> get props => [
    id,
    otherUserName,
    otherUserImage,
    lastMessage,
    unreadCount,
    lastMessageTime,
  ];
}
