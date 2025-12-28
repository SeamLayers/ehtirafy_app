import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class GetMessagesUseCase {
  final ChatRepository repository;

  GetMessagesUseCase(this.repository);

  Future<Either<Failure, List<MessageEntity>>> call(
    String chatId, {
    String userType = 'customer',
  }) async {
    return await repository.getMessages(chatId, userType: userType);
  }
}
