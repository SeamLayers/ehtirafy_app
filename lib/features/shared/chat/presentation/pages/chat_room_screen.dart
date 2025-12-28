import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/message_bubble.dart';
import 'package:ehtirafy_app/core/widgets/outlined_refresh_button.dart';

class ChatRoomScreen extends StatefulWidget {
  final ConversationEntity conversation;
  final String userType;

  const ChatRoomScreen({
    super.key,
    required this.conversation,
    this.userType = 'customer',
  });

  @override
  State<ChatRoomScreen> createState() => _ChatRoomScreenState();
}

class _ChatRoomScreenState extends State<ChatRoomScreen> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadMessages(
      widget.conversation.id,
      userType: widget.userType,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is ChatError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        appBar: AppBar(
          backgroundColor: const Color(0xFF2B2B2B),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.network(
                  widget.conversation.otherUserImage,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFF3A3A3A),
                    child: Icon(
                      Icons.person_outline,
                      color: Colors.white70,
                      size: 22.r,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.conversation.otherUserName,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  Text(
                    AppStrings.chatOnlineNow.tr(),
                    style: TextStyle(
                      color: const Color(0xB2FFFEFE),
                      fontSize: 12.sp,
                      fontFamily: 'Cairo',
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.white),
              onPressed: () {},
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
          ),
        ),
        body: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedRefreshButton(
                    onPressed: () {
                      context.read<ChatCubit>().loadMessages(
                        widget.conversation.id,
                        userType: widget.userType,
                      );
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                buildWhen: (previous, current) =>
                    current is MessagesLoaded ||
                    current is ChatLoading ||
                    current is ChatError,
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatError) {
                    // Also show center text if needed, or just rely on SnackBar
                    return Center(child: Text(state.message));
                  } else if (state is MessagesLoaded) {
                    return ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.symmetric(vertical: 24.h),
                      itemCount: state.messages.length,
                      itemBuilder: (context, index) {
                        final message = state.messages[index];
                        // Assuming 'me' is the current user ID for now
                        final isMe = message.senderId == 'me';
                        return MessageBubble(message: message, isMe: isMe);
                      },
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            ChatInputBar(
              controller: _controller,
              onSend: () {
                if (_controller.text.trim().isNotEmpty) {
                  final message = MessageEntity(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    senderId: 'me',
                    receiverId: widget
                        .conversation
                        .id, // Assuming conversation ID maps to user ID for now
                    content: _controller.text.trim(),
                    timestamp: DateTime.now(),
                    isRead: false,
                  );
                  context.read<ChatCubit>().sendMessage(
                    message,
                    userType: widget.userType,
                  );
                  _controller.clear();
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
