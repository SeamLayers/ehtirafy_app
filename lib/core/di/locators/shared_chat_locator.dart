import 'package:ehtirafy_app/features/shared/chat/data/datasources/chat_remote_data_source.dart';
import 'package:ehtirafy_app/features/shared/chat/data/repositories/chat_repository_impl.dart';
import 'package:ehtirafy_app/features/shared/chat/domain/repositories/chat_repository.dart';
import 'package:ehtirafy_app/features/shared/chat/domain/usecases/get_conversations_usecase.dart';
import 'package:ehtirafy_app/features/shared/chat/domain/usecases/get_messages_usecase.dart';
import 'package:ehtirafy_app/features/shared/chat/domain/usecases/send_message_usecase.dart';
import 'package:ehtirafy_app/features/shared/chat/presentation/cubit/chat_cubit.dart';
import 'package:get_it/get_it.dart';

extension SharedChatLocator on GetIt {
  void registerSharedChatDependencies() {
    registerFactory(
      () => ChatCubit(
        getConversationsUseCase: this(),
        getMessagesUseCase: this(),
        sendMessageUseCase: this(),
      ),
    );
    registerLazySingleton(() => GetConversationsUseCase(this()));
    registerLazySingleton(() => GetMessagesUseCase(this()));
    registerLazySingleton(() => SendMessageUseCase(this()));
    registerLazySingleton<ChatRepository>(() => ChatRepositoryImpl(this()));
    registerLazySingleton<ChatRemoteDataSource>(
      () => ChatRemoteDataSourceImpl(dioClient: this()),
    );
  }
}
