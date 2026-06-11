import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/constants/app_spacing.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:ehtirafy_app/features/client/notifications/presentation/cubits/notifications_cubit.dart';
import 'package:ehtirafy_app/features/client/notifications/presentation/cubits/notifications_state.dart';
import 'package:ehtirafy_app/features/client/notifications/domain/entities/notification_entity.dart';
import 'package:ehtirafy_app/core/widgets/custom_empty_state.dart';
import 'package:ehtirafy_app/core/widgets/error_state_widget.dart';
import 'package:ehtirafy_app/core/widgets/rtl_back_button.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NotificationsCubit>()..getNotifications(),
      child: Scaffold(
        backgroundColor: AppColors.backgroundLight,
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          scrolledUnderElevation: 0,
          title: Text(
            AppStrings.notificationsTitle.tr(),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: AppColors.dark,
          foregroundColor: Colors.white,
          leading: RtlBackButton(
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromHeight(1.h),
            child: Container(
              height: 1.h,
              color: AppColors.gold.withValues(alpha: 0.35),
            ),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  if (state is NotificationsLoading) {
                    return Center(
                      child: SizedBox(
                        width: 36.w,
                        height: 36.w,
                        child: CircularProgressIndicator(
                          strokeWidth: 3.w,
                          valueColor: const AlwaysStoppedAnimation<Color>(
                            AppColors.gold,
                          ),
                        ),
                      ),
                    );
                  } else if (state is NotificationsError) {
                    return ErrorStateWidget(
                      message: state.message,
                      onRetry: () => context
                          .read<NotificationsCubit>()
                          .getNotifications(),
                    );
                  } else if (state is NotificationsLoaded) {
                    return Column(
                      children: [
                        _buildFilterTabs(context, state.filter),
                        Expanded(
                          child: state.notifications.isEmpty
                              ? Center(
                                  child: EmptyStateWidget(
                                    message: AppStrings.notificationsEmpty.tr(),
                                    icon: Icons.notifications_off_outlined,
                                  ),
                                )
                              : ListView.separated(
                                  padding: EdgeInsets.fromLTRB(
                                    AppSpacing.md,
                                    AppSpacing.xs,
                                    AppSpacing.md,
                                    AppSpacing.md,
                                  ),
                                  itemCount: state.notifications.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: AppSpacing.sm + 4.h),
                                  itemBuilder: (context, index) {
                                    final notification =
                                        state.notifications[index];
                                    return _NotificationItem(
                                      notification: notification,
                                      onTap: () {
                                        if (notification.isUnread) {
                                          context
                                              .read<NotificationsCubit>()
                                              .markAsRead(notification.id);
                                        }
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

  Widget _buildFilterTabs(BuildContext context, String currentFilter) {
    return Container(
      margin: EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.sm,
      ),
      padding: EdgeInsets.all(5.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.grey200),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowLight,
            blurRadius: 12.r,
            offset: Offset(0, 4.h),
          ),
        ],
      ),
      child: Row(
        children: [
          _buildTab(
            context,
            text: AppStrings.notificationsUnread.tr(),
            isSelected: currentFilter == 'unread',
            onTap: () => context.read<NotificationsCubit>().filterNotifications(
              'unread',
            ),
          ),
          _buildTab(
            context,
            text: AppStrings.notificationsAll.tr(),
            isSelected: currentFilter == 'all',
            onTap: () =>
                context.read<NotificationsCubit>().filterNotifications('all'),
          ),
        ],
      ),
    );
  }

  Widget _buildTab(
    BuildContext context, {
    required String text,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeOut,
          padding: EdgeInsets.symmetric(vertical: 10.h),
          decoration: BoxDecoration(
            gradient: isSelected
                ? LinearGradient(
                    colors: [
                      AppColors.gold,
                      AppColors.gold.withValues(alpha: 0.85),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  )
                : null,
            color: isSelected ? null : Colors.transparent,
            borderRadius: BorderRadius.circular(10.r),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: AppColors.gold.withValues(alpha: 0.30),
                      blurRadius: 10.r,
                      offset: Offset(0, 3.h),
                    ),
                  ]
                : null,
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected ? Colors.white : AppColors.grey600,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _NotificationItem extends StatelessWidget {
  final NotificationEntity notification;
  final VoidCallback onTap;

  const _NotificationItem({required this.notification, required this.onTap});

  IconData _iconForType(String type) {
    final t = type.toLowerCase();
    if (t.contains('book') || t.contains('order') || t.contains('reserv')) {
      return Icons.event_available_rounded;
    }
    if (t.contains('pay') || t.contains('wallet') || t.contains('money')) {
      return Icons.payments_rounded;
    }
    if (t.contains('message') || t.contains('chat')) {
      return Icons.chat_bubble_rounded;
    }
    if (t.contains('review') || t.contains('rate') || t.contains('star')) {
      return Icons.star_rounded;
    }
    if (t.contains('offer') || t.contains('promo') || t.contains('discount')) {
      return Icons.local_offer_rounded;
    }
    return Icons.notifications_rounded;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bool isUnread = notification.isUnread;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          padding: EdgeInsets.all(AppSpacing.md),
          decoration: BoxDecoration(
            color: isUnread
                ? AppColors.gold.withValues(alpha: 0.06)
                : Colors.white,
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: isUnread
                  ? AppColors.gold.withValues(alpha: 0.45)
                  : AppColors.grey200,
              width: 1.w,
            ),
            boxShadow: [
              BoxShadow(
                color: isUnread
                    ? AppColors.gold.withValues(alpha: 0.10)
                    : AppColors.shadowLight,
                blurRadius: 14.r,
                offset: Offset(0, 5.h),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44.w,
                height: 44.w,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.gold.withValues(alpha: isUnread ? 0.20 : 0.12),
                      AppColors.gold.withValues(alpha: isUnread ? 0.10 : 0.06),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  _iconForType(notification.type),
                  color: AppColors.gold,
                  size: 22.sp,
                ),
              ),
              SizedBox(width: AppSpacing.sm + 4.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            notification.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ),
                        if (isUnread) ...[
                          SizedBox(width: AppSpacing.sm),
                          Container(
                            margin: EdgeInsets.only(top: 5.h),
                            width: 9.w,
                            height: 9.w,
                            decoration: BoxDecoration(
                              color: AppColors.gold,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.gold.withValues(alpha: 0.45),
                                  blurRadius: 6.r,
                                  spreadRadius: 1.r,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                    SizedBox(height: 6.h),
                    Text(
                      notification.body,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: AppColors.textSecondary,
                        height: 1.4,
                      ),
                    ),
                    SizedBox(height: AppSpacing.sm + 2.h),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_rounded,
                          size: 13.sp,
                          color: AppColors.grey400,
                        ),
                        SizedBox(width: AppSpacing.xs),
                        Flexible(
                          child: Text(
                            notification.time,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: AppColors.grey500,
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
        ),
      ),
    );
  }
}
