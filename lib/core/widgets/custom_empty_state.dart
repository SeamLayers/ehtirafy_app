import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../constants/app_spacing.dart';
import '../theme/app_colors.dart';
import 'primary_button.dart';

class CustomEmptyState extends StatelessWidget {
  final String title;
  final String? message;
  final bool localizeText;
  final IconData icon;
  final double iconSize;
  final String? actionKey;
  final VoidCallback? onAction;
  final String? actionText;
  final String? retryText;

  const CustomEmptyState({
    super.key,
    required this.title,
    this.message,
    this.localizeText = false,
    this.icon = Icons.photo_library_outlined,
    this.iconSize = 64,
    this.actionKey,
    this.onAction,
    this.actionText,
    this.retryText,
  });

  const CustomEmptyState.localized({
    super.key,
    required String titleKey,
    String? messageKey,
    this.icon = Icons.photo_library_outlined,
    this.iconSize = 64,
    this.actionKey,
    this.onAction,
    this.actionText,
    this.retryText,
  }) : title = titleKey,
       message = messageKey,
       localizeText = true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final resolvedTitle = localizeText ? title.tr() : title;
    final resolvedMessage = message == null
        ? null
        : (localizeText ? message!.tr() : message!);
    final resolvedAction = actionText ?? (actionKey != null ? actionKey!.tr() : null);

    return Center(
      child: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80.w,
              height: 80.h,
              decoration: BoxDecoration(
                color: const Color(0xFFF9F9F9),
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFFE5E5E5), width: 2),
              ),
              child: Icon(icon, size: iconSize.sp, color: Colors.grey),
            ),
            SizedBox(height: AppSpacing.md),
            Text(
              resolvedTitle,
              style: theme.textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            if (resolvedMessage != null) ...[
              SizedBox(height: AppSpacing.sm),
              Text(
                resolvedMessage,
                style: theme.textTheme.bodyMedium?.copyWith(color: AppColors.textSecondary),
                textAlign: TextAlign.center,
              ),
            ],
            if (resolvedAction != null && onAction != null) ...[
              SizedBox(height: AppSpacing.lg),
              PrimaryButton(text: resolvedAction, onPressed: onAction!),
            ],
          ],
        ),
      ),
    );
  }
}

class EmptyStateWidget extends StatelessWidget {
  final String message;
  final String? subMessage;
  final IconData icon;
  final VoidCallback? onRetry;
  final String? retryText;

  const EmptyStateWidget({
    super.key,
    required this.message,
    this.subMessage,
    this.icon = Icons.info_outline,
    this.onRetry,
    this.retryText,
  });

  @override
  Widget build(BuildContext context) {
    return CustomEmptyState(
      title: message,
      message: subMessage,
      icon: icon,
      iconSize: 40,
      actionText: retryText ?? 'Retry',
      onAction: onRetry,
    );
  }
}

