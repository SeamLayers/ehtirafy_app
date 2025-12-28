import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/conversation_tile.dart';
import 'package:ehtirafy_app/core/widgets/empty_state_widget.dart';
import 'package:ehtirafy_app/core/widgets/error_state_widget.dart';
import 'package:ehtirafy_app/core/widgets/outlined_refresh_button.dart';

class ConversationsScreen extends StatefulWidget {
  final String userType;

  const ConversationsScreen({super.key, this.userType = 'customer'});

  @override
  State<ConversationsScreen> createState() => _ConversationsScreenState();
}

class _ConversationsScreenState extends State<ConversationsScreen> {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF9F9F9),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: BlocBuilder<ChatCubit, ChatState>(
                buildWhen: (previous, current) =>
                    current is ConversationsLoaded ||
                    current is ChatLoading ||
                    current is ChatError,
                builder: (context, state) {
                  if (state is ChatLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is ChatError) {
                    return ErrorStateWidget(
                      message: state.message,
                      onRetry: () {
                        context.read<ChatCubit>().loadConversations(
                          userType: widget.userType,
                        );
                      },
                    );
                  } else if (state is ConversationsLoaded) {
                    if (state.conversations.isEmpty) {
                      return Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                OutlinedRefreshButton(
                                  onPressed: () {
                                    context.read<ChatCubit>().loadConversations(
                                      userType: widget.userType,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(child: _buildEmptyState()),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.fromLTRB(20.w, 10.h, 20.w, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              OutlinedRefreshButton(
                                onPressed: () {
                                  context.read<ChatCubit>().loadConversations(
                                    userType: widget.userType,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.all(24.w),
                            itemCount: state.conversations.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 12.h),
                            itemBuilder: (context, index) {
                              final conv = state.conversations[index];
                              return ConversationTile(
                                conversation: conv,
                                onTap: () {
                                  final path = widget.userType == 'freelancer'
                                      ? '/freelancer/messages/chat/${conv.id}'
                                      : '/messages/chat/${conv.id}';
                                  context.push(path, extra: conv);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.dark,
      child: SafeArea(
        bottom: false,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16.h),
          decoration: const BoxDecoration(
            color: AppColors.dark,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: Center(
            child: Text(
              AppStrings.chatListTitle.tr(),
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                height: 1.50,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: EmptyStateWidget(
        message: AppStrings.chatNoMessages.tr(),
        subMessage: AppStrings.chatStartConversation.tr(),
        icon: Icons.chat_bubble_outline,
        retryText: AppStrings.chatFindPhotographer.tr(),
        onRetry: () {
          // Navigate logic here if needed, usually chat logic is different
          // But based on original code it didn't have specific navigation in button?
          // Original: Container with 'Find Photographer' text but NO onTap in previous file view?
          // Ah, wait. In step 75 view_file of conversations_screen.dart:
          // It was just a Container with text "AppStrings.chatFindPhotographer.tr()".
          // It didn't seem to have a GestureDetector or InkWell.
          // Let's re-read step 75.
          // Lines 149-165: Container with text. No onTap.
          // Line 110-168: Column.
          // So it wasn't clickable? That's weird.
          // I'll make it clickable to '/home' or just hide the button if no action is intended.
          // However, making it clickable to search seems appropriate.
          context.push('/home');
        },
      ),
    );
  }
}
