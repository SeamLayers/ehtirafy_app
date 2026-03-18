import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import 'error_state_widget.dart';
import 'custom_empty_state.dart';

/// Generic state builder for handling multiple states
class StateAwareBuilder<T> extends StatelessWidget {
  final bool isLoading;
  final bool hasError;
  final bool isEmpty;
  final String? errorMessage;
  final String emptyTitle;
  final String emptyMessage;
  final VoidCallback? onRetry;
  final Widget Function(BuildContext context) builder;

  const StateAwareBuilder({
    super.key,
    required this.isLoading,
    required this.hasError,
    required this.isEmpty,
    this.errorMessage,
    required this.emptyTitle,
    required this.emptyMessage,
    this.onRetry,
    required this.builder,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.gold),
        ),
      );
    }

    if (hasError) {
      return ErrorStateWidget(
        message: errorMessage ?? 'حدث خطأ غير متوقع. يرجى المحاولة لاحقاً',
        onRetry: onRetry,
      );
    }

    if (isEmpty) {
      return EmptyStateWidget(
        message: emptyTitle, // Mapping title to message for compatibility
        subMessage: emptyMessage,
      );
    }

    return builder(context);
  }
}
