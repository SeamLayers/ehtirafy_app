import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
        child: Container(
          padding: EdgeInsets.all(20.r),
          decoration: BoxDecoration(
            color: AppColors.textLight,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppColors.gold.withValues(alpha: 0.18),
              width: 1.r,
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.gold.withValues(alpha: 0.12),
                blurRadius: 16.r,
                offset: Offset(0, 4.h),
              ),
            ],
          ),
          child: SizedBox(
            width: 36.r,
            height: 36.r,
            child: CircularProgressIndicator(
              strokeWidth: 3.r,
              valueColor:
                  const AlwaysStoppedAnimation<Color>(AppColors.gold),
            ),
          ),
        ),
      );
    }

    if (hasError) {
      return ErrorStateWidget(
        message: errorMessage ?? 'حدث خطأ غير متوقع. يرجى المحاولة لاحقاً',
        onRetry: onRetry ?? () {},
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
