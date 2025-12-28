import 'package:dartz/dartz.dart';
import 'package:ehtirafy_app/core/error/failures.dart';
import '../entities/message_entity.dart';
import '../repositories/chat_repository.dart';

class SendMessageUseCase {
  final ChatRepository repository;

  SendMessageUseCase(this.repository);

  Future<Either<Failure, void>> call(
    MessageEntity message, {
    String userType = 'customer',
  }) async {
    return await repository.sendMessage(message, userType: userType);
  }
}
