import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import '../entities/conversation_entity.dart';
import '../repositories/chat_repository.dart';

class GetConversationsUseCase {
  final ChatRepository repository;

  GetConversationsUseCase(this.repository);

  Future<Either<Failure, List<ConversationEntity>>> call({
    String userType = 'customer',
  }) async {
    return await repository.getConversations(userType: userType);
  }
}
