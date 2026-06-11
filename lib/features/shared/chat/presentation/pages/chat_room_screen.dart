import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/widgets/user_avatar.dart';
import 'package:ehtirafy_app/core/widgets/error_state_widget.dart';
import 'package:ehtirafy_app/core/widgets/custom_empty_state.dart';
import '../../domain/entities/conversation_entity.dart';
import '../../domain/entities/message_entity.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/chat_input_bar.dart';
import '../widgets/message_bubble.dart';


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

  void _reload() {
    context.read<ChatCubit>().loadMessages(
      widget.conversation.id,
      userType: widget.userType,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isRtl = Directionality.of(context) == ui.TextDirection.rtl;
    return BlocListener<ChatCubit, ChatState>(
      listener: (context, state) {
        if (state is MessagesLoaded) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('تم تحديث الرسائل'),
              backgroundColor: AppColors.success,
              behavior: SnackBarBehavior.floating,
              duration: const Duration(seconds: 1),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
        } else if (state is ChatError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: AppColors.error,
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          );
        }
      },
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: _buildAppBar(isRtl),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                buildWhen: (previous, current) =>
                    current is MessagesLoaded ||
                    current is ChatLoading ||
                    current is ChatError,
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return Center(
                      child: SizedBox(
                        width: 36.r,
                        height: 36.r,
                        child: const CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            AppColors.gold,
                          ),
                        ),
                      ),
                    );
                  } else if (state is ChatError) {
                    return ErrorStateWidget(
                      message: state.message,
                      onRetry: _reload,
                      retryText: 'إعادة المحاولة',
                    );
                  } else if (state is MessagesLoaded) {
                    if (state.messages.isEmpty) {
                      return CustomEmptyState(
                        title: AppStrings.chatNoMessages.tr(),
                        icon: Icons.forum_outlined,
                      );
                    }
                    return ListView.builder(
                      reverse: true,
                      padding: EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                        horizontal: AppSpacing.xs,
                      ),
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

  PreferredSizeWidget _buildAppBar(bool isRtl) {
    return AppBar(
      backgroundColor: AppColors.dark,
      elevation: 0,
      scrolledUnderElevation: 0,
      titleSpacing: 0,
      leadingWidth: 44.w,
      leading: IconButton(
        splashRadius: 22.r,
        icon: Icon(
          isRtl
              ? Icons.arrow_forward_ios_rounded
              : Icons.arrow_back_ios_new_rounded,
          color: AppColors.textLight,
          size: 20.sp,
        ),
        onPressed: () => Navigator.pop(context),
        tooltip: isRtl ? 'رجوع' : 'Back',
      ),
      title: Row(
        children: [
          UserAvatar(
            name: widget.conversation.otherUserName,
            imageUrl: widget.conversation.otherUserImage,
            size: 42,
          ),
          SizedBox(width: AppSpacing.sm + 2.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.conversation.otherUserName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: AppColors.textLight,
                    fontSize: 16.sp,
                    fontFamily: 'Cairo',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 7.r,
                      height: 7.r,
                      decoration: const BoxDecoration(
                        color: AppColors.success,
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(width: 6.w),
                    Flexible(
                      child: Text(
                        AppStrings.chatOnlineNow.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: AppColors.textLight.withValues(alpha: 0.70),
                          fontSize: 12.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        Padding(
          padding: EdgeInsetsDirectional.only(end: AppSpacing.xs),
          child: IconButton(
            splashRadius: 22.r,
            icon: Icon(
              Icons.refresh_rounded,
              color: AppColors.gold,
              size: 22.sp,
            ),
            onPressed: _reload,
          ),
        ),
      ],
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24.r)),
      ),
    );
  }
}
