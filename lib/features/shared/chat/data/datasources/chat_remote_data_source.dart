import 'package:ehtirafy_app/core/network/dio_client.dart';
import 'package:ehtirafy_app/core/errors/exceptions.dart';
import 'package:ehtirafy_app/features/client/contract/data/models/contract_model.dart';
import 'package:ehtirafy_app/core/network/api_constants.dart';
import 'package:dio/dio.dart';

import '../models/conversation_model.dart';
import '../models/message_model.dart';

abstract class ChatRemoteDataSource {
  Future<List<ConversationModel>> getConversations({
    String userType = 'customer',
  });
  Stream<List<ConversationModel>> watchConversations({
    String userType = 'customer',
  });
  Future<List<MessageModel>> getMessages(
    String contractId, {
    String userType = 'customer',
  });
  Stream<List<MessageModel>> watchMessages(
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
        options: Options(
          extra: {
            'disableCache': true,
            'cache_ttl': Duration.zero,
          },
        ),
      );

      final data = response.data;
      if (data['status'] == 200 || data['success'] == true) {
        final dynamic responseData = data['data'];
        List list = [];
        if (responseData is List) {
          list = responseData;
        } else if (responseData == null) {
          list = [];
        }

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
        throw ServerException(data['message'] ?? 'فشل في جلب المحادثات');
      }
    } catch (e) {
      if (e is ServerException) rethrow;
      throw ServerException(e.toString());
    }
  }

  @override
  Stream<List<ConversationModel>> watchConversations({
    String userType = 'customer',
  }) {
    // Firebase migration hook: swap this with realtime database stream.
    return Stream.fromFuture(getConversations(userType: userType));
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

      // Determine the "other" name to match against creator field
      // API returns creator like "Ahmed (Photographer)" or "Al-Aqeel (Customer)"
      final myName = userType == 'freelancer'
          ? (contract.photographerName ?? '')
          : (contract.clientName ?? '');

      // Map chat messages to MessageModel
      return messages
          .asMap()
          .entries
          .map((entry) {
            final index = entry.key;
            final msg = entry.value;

            // Identify sender using user_type field (customer/freelancer)
            // and fallback to creator name matching
            final msgUserType = msg['user_type'] ?? '';
            final creator = msg['creator'] ?? '';

            // Primary: match by user_type field
            // Freelancer messages have user_type='freelancer', customer have user_type='customer'
            bool isFromMe;
            if (msgUserType == 'freelancer' || msgUserType == 'publisher') {
              isFromMe = userType == 'freelancer';
            } else if (msgUserType == 'customer') {
              isFromMe = userType == 'customer';
            } else {
              // Fallback: match by creator name
              isFromMe = myName.isNotEmpty && creator.contains(myName);
            }

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
  Stream<List<MessageModel>> watchMessages(
    String contractId, {
    String userType = 'customer',
  }) {
    // Firebase migration hook: swap this with realtime database stream.
    return Stream.fromFuture(
      getMessages(contractId, userType: userType),
    );
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
      // API note_type: 'customer' for customers, 'freelancer' for photographers
      // customer notes go to contr_cust_notes, freelancer notes go to contr_pub_notes
      final noteType = userType == 'freelancer' ? 'freelancer' : 'customer';

      // Find cached contract to keep the current contract_status unchanged
      String? currentStatus;
      try {
        final contract = _cachedContracts.firstWhere(
          (c) => c.id.toString() == message.receiverId,
        );
        currentStatus = contract.contractStatus;
      } catch (_) {}

      final data = <String, dynamic>{
        '_method': 'PUT',
        'user_type': noteType,
        'note_type': noteType,
        'note_text': message.content,
        'contract_status': currentStatus ?? 'Initiate',
      };

      final response = await dioClient.post(
        ApiConstants.updateContract(message.receiverId),
        data: data,
      );

      final responseData = response.data;
      if (responseData['success'] != true && responseData['status'] != 200) {
        throw ServerException(responseData['message'] ?? 'فشل في إرسال الرسالة');
      }

      // Update cache with the returned contract data
      if (responseData['data'] != null) {
        try {
          final updatedContract = ContractModel.fromJson(responseData['data']);
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
