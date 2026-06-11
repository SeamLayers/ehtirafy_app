import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

import 'package:ehtirafy_app/core/constants/app_spacing.dart';

import '../cubit/chat_cubit.dart';
import '../cubit/chat_state.dart';
import '../widgets/conversation_tile.dart';
import 'package:ehtirafy_app/core/widgets/custom_empty_state.dart';
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
                    return Center(
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5.w,
                        valueColor: const AlwaysStoppedAnimation<Color>(
                          AppColors.gold,
                        ),
                      ),
                    );
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
                          _buildRefreshBar(context),
                          Expanded(child: _buildEmptyState()),
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
              colors: [
                AppColors.dark,
                AppColors.dark.withValues(alpha: 0.92),
              ],
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
                      Icons.forum_rounded,
                      color: AppColors.gold,
                      size: 18.sp,
                    ),
                    SizedBox(width: AppSpacing.sm),
                    Flexible(
                      child: Text(
                        AppStrings.chatListTitle.tr(),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          height: 1.50,
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
            onPressed: () {
              context.read<ChatCubit>().loadConversations(
                userType: widget.userType,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    final isFreelancer = widget.userType == 'freelancer';

    return Center(
      child: EmptyStateWidget(
        message: isFreelancer
            ? AppStrings.chatFreelancerNoMessages.tr()
            : AppStrings.chatNoMessages.tr(),
        subMessage: isFreelancer
            ? AppStrings.chatFreelancerStartConversation.tr()
            : AppStrings.chatStartConversation.tr(),
        icon: isFreelancer ? Icons.work_outline : Icons.chat_bubble_outline,
        retryText: isFreelancer
            ? AppStrings.chatFreelancerExploreGigs.tr()
            : AppStrings.chatFindPhotographer.tr(),
        onRetry: () {
          if (isFreelancer) {
            context.push('/freelancer/gigs');
          } else {
            context.push('/home');
          }
        },
      ),
    );
  }
}
