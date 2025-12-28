import 'package:ehtirafy_app/core/network/dio_client.dart';
import 'package:ehtirafy_app/core/error/exceptions.dart';
import 'package:ehtirafy_app/features/client/contract/data/models/contract_model.dart';
import 'package:ehtirafy_app/core/network/api_constants.dart';

import '../models/conversation_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ConversationModel>> getConversations({
    String userType = 'customer',
  });
  Future<List<MessageModel>> getMessages(
    String contractId, {
    String userType = 'customer',
  });
  Future<void> sendMessage(
    MessageModel message, {
    String userType = 'customer',
  });
}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final DioClient dioClient;

  // Cache contracts for message retrieval
  List<ContractModel> _cachedContracts = [];

  ChatRemoteDataSourceImpl({required this.dioClient});

  @override
  Future<List<ConversationModel>> getConversations({
    String userType = 'customer',
  }) async {
    try {
      // Fetch contracts from API
      // Query param user_type determines if we are looking as customer or freelancer
      final response = await dioClient.get(
        '/api/v1/front/contracts-relative',
        queryParameters: {'user_type': userType},
      );

      final data = response.data;
      if (data['status'] == 200) {
        final List list = data['data'] ?? [];
        _cachedContracts = list.map((e) => ContractModel.fromJson(e)).toList();

        // Filter contracts where chat is allowed (only accepted contracts)
        final chatAllowedContracts = _cachedContracts
            .where((contract) => contract.isChatAllowed)
            .toList();

        // Map contracts to conversations
        return chatAllowedContracts.map((contract) {
          // Get last message from chat messages
          String lastMessage = '';
          DateTime lastMessageTime = contract.updatedAt;

          if (contract.chatMessages != null &&
              contract.chatMessages!.isNotEmpty) {
            final lastMsg = contract.chatMessages!.last;
            lastMessage = lastMsg['note'] ?? '';
            try {
              lastMessageTime =
                  DateTime.tryParse(lastMsg['date'] ?? '') ??
                  contract.updatedAt;
            } catch (_) {}
          }

          // Determine "Other" user based on my role
          final isFreelancer = userType == 'freelancer';
          final otherName = isFreelancer
              ? (contract.clientName ?? '')
              : (contract.photographerName ?? '');
          final otherImage = isFreelancer
              ? (contract.clientImage ?? '')
              : (contract.photographerImage ?? '');

          return ConversationModel(
            id: contract.id.toString(),
            otherUserName: otherName.isNotEmpty
                ? otherName
                : (isFreelancer ? 'عميل' : 'مصور'),
            otherUserImage: otherImage,
            lastMessage: lastMessage.isEmpty ? 'ابدأ المحادثة...' : lastMessage,
            unreadCount: 0, // TODO: Track unread count
            lastMessageTime: lastMessageTime,
          );
        }).toList();
      } else {
        throw ServerException(
          data['message'] ?? 'Failed to fetch conversations',
        );
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<List<MessageModel>> getMessages(
    String contractId, {
    String userType = 'customer',
  }) async {
    try {
      // Find contract in cache or fetch again
      ContractModel? contract;
      try {
        contract = _cachedContracts.firstWhere(
          (c) => c.id.toString() == contractId,
        );
      } catch (_) {
        // Contract not in cache, fetch fresh data
        await getConversations(userType: userType);
        try {
          contract = _cachedContracts.firstWhere(
            (c) => c.id.toString() == contractId,
          );
        } catch (_) {
          return [];
        }
      }

      if (contract.chatMessages == null || contract.chatMessages!.isEmpty) {
        return [];
      }

      // Get current user info to determine sender/receiver
      final otherUserId = userType == 'freelancer'
          ? contract.clientId
          : contract.photographerId;
      final messages = contract.chatMessages!;

      // Map chat messages to MessageModel
      return messages
          .asMap()
          .entries
          .map((entry) {
            final index = entry.key;
            final msg = entry.value;

            final msgUserType = msg['user_type'] ?? '';

            // Logic: if msgUserType matches my userType, it is from me.
            final isFromMe = msgUserType == userType;

            DateTime timestamp;
            try {
              timestamp =
                  DateTime.tryParse(msg['date'] ?? '') ?? DateTime.now();
            } catch (_) {
              timestamp = DateTime.now();
            }

            return MessageModel(
              id: '${contractId}_$index',
              senderId: isFromMe
                  ? 'me'
                  : otherUserId, // Using 'me' simplifies UI logic
              receiverId: isFromMe ? otherUserId : 'me',
              content: msg['note'] ?? '',
              timestamp: timestamp,
              isRead: true,
            );
          })
          .toList()
          .reversed
          .toList();
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Future<void> sendMessage(
    MessageModel message, {
    String userType = 'customer',
  }) async {
    try {
      // Send message via contract update API with note
      // The message.receiverId contains the contractId for our implementation
      // We need to extract contractId from the message context

      // For now, we'll use the contract update endpoint
      // Using ApiConstants for consistency and correctness
      final response = await dioClient.post(
        ApiConstants.updateContract(message.receiverId),
        data: {
          '_method': 'PUT',
          'note_type': userType, // Dynamic note type
          'note_text': message.content,
        },
      );

      final data = response.data;
      if (data['status'] != 200) {
        throw ServerException(data['message'] ?? 'Failed to send message');
      }

      // Update cache with the returned contract data
      if (data['data'] != null) {
        try {
          final updatedContract = ContractModel.fromJson(data['data']);
          final index = _cachedContracts.indexWhere(
            (c) => c.id == updatedContract.id,
          );
          if (index != -1) {
            _cachedContracts[index] = updatedContract;
          } else {
            _cachedContracts.add(updatedContract);
          }
        } catch (_) {
          // If parsing fails, just clear/invalidate this contract from cache to force fetch next time
          _cachedContracts.removeWhere(
            (c) => c.id.toString() == message.receiverId,
          );
        }
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }
}
