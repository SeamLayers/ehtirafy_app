import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/usecases/get_conversations_usecase.dart';
import '../../domain/usecases/get_messages_usecase.dart';
import '../../domain/usecases/send_message_usecase.dart';
import 'chat_state.dart';

class ChatCubit extends Cubit<ChatState> {
  final GetConversationsUseCase getConversationsUseCase;
  final GetMessagesUseCase getMessagesUseCase;
  final SendMessageUseCase sendMessageUseCase;

  ChatCubit({
    required this.getConversationsUseCase,
    required this.getMessagesUseCase,
    required this.sendMessageUseCase,
  }) : super(ChatInitial());

  Future<void> loadConversations({String userType = 'customer'}) async {
    emit(ChatLoading());
    final result = await getConversationsUseCase(userType: userType);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (conversations) => emit(ConversationsLoaded(conversations)),
    );
  }

  /// Loads BOTH sides of the user's conversations for the unified
  /// "Contracts & Chats" tab: ones where the user is the buyer (customer) and
  /// ones where the user is the advertiser (freelancer), merged and de-duped
  /// by contract id. Everyone is a standard user now, so they may have both.
  Future<void> loadAllConversations() async {
    emit(ChatLoading());
    final results = await Future.wait([
      getConversationsUseCase(userType: 'customer'),
      getConversationsUseCase(userType: 'freelancer'),
    ]);

    final merged = <String, ConversationEntity>{};
    var anySuccess = false;
    String? firstError;

    for (final result in results) {
      result.fold(
        (failure) => firstError ??= failure.message,
        (conversations) {
          anySuccess = true;
          for (final conv in conversations) {
            merged.putIfAbsent(conv.id, () => conv);
          }
        },
      );
    }

    if (!anySuccess) {
      emit(ChatError(firstError ?? 'error'));
      return;
    }

    final list = merged.values.toList()
      ..sort((a, b) => b.lastMessageTime.compareTo(a.lastMessageTime));
    emit(ConversationsLoaded(list));
  }

  Future<void> loadMessages(
    String chatId, {
    String userType = 'customer',
  }) async {
    emit(ChatLoading());
    final result = await getMessagesUseCase(chatId, userType: userType);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (messages) => emit(MessagesLoaded(messages)),
    );
  }

  Future<void> sendMessage(
    MessageEntity message, {
    String userType = 'customer',
  }) async {
    // Optimistic update or just send and reload
    // For now, let's just send and reload messages
    final result = await sendMessageUseCase(message, userType: userType);
    result.fold(
      (failure) => emit(ChatError(failure.message)),
      (_) => loadMessages(
        message.receiverId == 'me' ? message.senderId : message.receiverId,
        userType: userType,
      ), // Reload messages
    );
  }
}
