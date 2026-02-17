import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ehtirafy_app/core/constants/app_strings.dart';
import 'package:ehtirafy_app/core/theme/app_colors.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';
import 'package:ehtirafy_app/features/client/notifications/presentation/cubits/notifications_cubit.dart';
import 'package:ehtirafy_app/features/client/notifications/presentation/cubits/notifications_state.dart';
import 'package:ehtirafy_app/features/client/notifications/domain/entities/notification_entity.dart';
import 'package:ehtirafy_app/core/widgets/empty_state_widget.dart';
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
          title: Text(AppStrings.notificationsTitle.tr()),
          backgroundColor: AppColors.dark,
          foregroundColor: Colors.white,
          leading: RtlBackButton(
            color: Colors.white,
            onPressed: () => Navigator.pop(context),
          ),
        ),
        body: Column(
          children: [
            Expanded(
              child: BlocBuilder<NotificationsCubit, NotificationsState>(
                builder: (context, state) {
                  if (state is NotificationsLoading) {
                    return const Center(child: CircularProgressIndicator());
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
                                  padding: EdgeInsets.all(16.w),
                                  itemCount: state.notifications.length,
                                  separatorBuilder: (_, __) =>
                                      SizedBox(height: 12.h),
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
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      padding: EdgeInsets.all(4.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.grey200),
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
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.h),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.gold : Colors.transparent,
            borderRadius: BorderRadius.circular(8.r),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: isSelected ? Colors.white : AppColors.grey600,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: notification.isUnread
              ? AppColors.gold.withOpacity(0.1)
              : Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: notification.isUnread
                ? AppColors.gold
                : Colors.grey.shade300,
            width: 1.w,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    notification.title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (notification.isUnread)
                  Container(
                    width: 8.w,
                    height: 8.w,
                    decoration: const BoxDecoration(
                      color: AppColors.gold,
                      shape: BoxShape.circle,
                    ),
                  ),
              ],
            ),
            SizedBox(height: 8.h),
            Text(
              notification.body,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            SizedBox(height: 8.h),
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                notification.time,
                style: Theme.of(
                  context,
                ).textTheme.bodySmall?.copyWith(color: Colors.grey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
