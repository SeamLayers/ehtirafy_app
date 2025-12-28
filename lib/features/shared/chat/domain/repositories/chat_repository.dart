import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import '../entities/conversation_entity.dart';
import '../entities/message_entity.dart';

abstract class ChatRepository {
  Future<Either<Failure, List<ConversationEntity>>> getConversations({
    String userType = 'customer',
  });
  Future<Either<Failure, List<MessageEntity>>> getMessages(
    String chatId, {
    String userType = 'customer',
  });
  Future<Either<Failure, void>> sendMessage(
    MessageEntity message, {
    String userType = 'customer',
  });
}
