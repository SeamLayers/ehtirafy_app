import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/chat_repository.dart';
import '../datasources/chat_remote_data_source.dart';
import '../models/message_model.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<Failure, List<ConversationEntity>>> getConversations({
    String userType = 'customer',
  }) async {
    try {
      final conversations = await remoteDataSource.getConversations(
        userType: userType,
      );
      return Right(conversations);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<MessageEntity>>> getMessages(
    String chatId, {
    String userType = 'customer',
  }) async {
    try {
      final messages = await remoteDataSource.getMessages(
        chatId,
        userType: userType,
      );
      return Right(messages);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendMessage(
    MessageEntity message, {
    String userType = 'customer',
  }) async {
    try {
      final messageModel = MessageModel(
        id: message.id,
        senderId: message.senderId,
        receiverId: message.receiverId,
        content: message.content,
        timestamp: message.timestamp,
        isRead: message.isRead,
      );
      await remoteDataSource.sendMessage(messageModel, userType: userType);
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}
