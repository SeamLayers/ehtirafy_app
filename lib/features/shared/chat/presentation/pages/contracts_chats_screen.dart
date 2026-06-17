import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/widgets/custom_empty_state.dart';
import 'package:ehtirafy_app/core/widgets/error_state_widget.dart';
import 'package:ehtirafy_app/core/widgets/outlined_refresh_button.dart';
import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/conversation_tile.dart';

/// Merged "Contracts & Chats" tab. Each row is a contract that also acts as a
/// conversation; tapping it opens the chat room with the associated customer
/// or freelancer directly.
class ContractsChatsScreen extends StatelessWidget {
  const ContractsChatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light.copyWith(
        statusBarColor: Colors.transparent,
      ),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
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
                    return const Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          AppColors.gold,
                        ),
                      ),
                    );
                  } else if (state is ChatError) {
                    return ErrorStateWidget(
                      message: AppStrings.contractsChatsLoadError.tr(),
                      retryText: AppStrings.contractsChatsRetry.tr(),
                      onRetry: () =>
                          context.read<ChatCubit>().loadAllConversations(),
                    );
                  } else if (state is ConversationsLoaded) {
                    if (state.conversations.isEmpty) {
                      return Column(
                        children: [
                          _buildRefreshBar(context),
                          Expanded(
                            child: CustomEmptyState(
                              title: AppStrings.chatNoMessages.tr(),
                              message: AppStrings.chatStartConversation.tr(),
                              icon: Icons.forum_outlined,
                              iconSize: 44,
                            ),
                          ),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        _buildRefreshBar(context),
                        Expanded(
                          child: ListView.separated(
                            padding: EdgeInsets.fromLTRB(
                              AppSpacing.lg,
                              AppSpacing.md,
                              AppSpacing.lg,
                              AppSpacing.lg,
                            ),
                            itemCount: state.conversations.length,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: AppSpacing.sm + AppSpacing.xs),
                            itemBuilder: (context, index) {
                              final conv = state.conversations[index];
                              return ConversationTile(
                                conversation: conv,
                                onTap: () => context.push(
                                  '/contracts-chats/chat/${conv.id}',
                                  extra: conv,
                                ),
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
    final radius = BorderRadius.only(
      bottomLeft: Radius.circular(24.r),
      bottomRight: Radius.circular(24.r),
    );

    return Container(
      decoration: BoxDecoration(
        borderRadius: radius,
        boxShadow: [
          BoxShadow(
            color: AppColors.dark.withValues(alpha: 0.18),
            blurRadius: 16.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: radius,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: AlignmentDirectional.topStart,
              end: AlignmentDirectional.bottomEnd,
              colors: [AppColors.dark, AppColors.dark.withValues(alpha: 0.92)],
            ),
            border: Border(
              bottom: BorderSide(
                color: AppColors.gold.withValues(alpha: 0.35),
                width: 1.5.h,
              ),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: AppSpacing.md),
              child: Center(
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.handshake_outlined,
                      color: AppColors.gold,
                      size: 18.sp,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        AppStrings.navContractsChats.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontFamily: 'Cairo',
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRefreshBar(BuildContext context) {
    return Padding(
      padding: EdgeInsetsDirectional.fromSTEB(
        AppSpacing.lg,
        AppSpacing.sm + AppSpacing.xs,
        AppSpacing.lg,
        0,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          OutlinedRefreshButton(
            onPressed: () =>
                context.read<ChatCubit>().loadAllConversations(),
          ),
        ],
      ),
    );
  }
}
