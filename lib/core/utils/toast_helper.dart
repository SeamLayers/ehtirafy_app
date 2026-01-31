import 'package:flutter/material.dart';

/// Global toast/snackbar management helper
/// Prevents duplicate toasts and manages their display
class ToastHelper {
  static final Map<String, DateTime> _lastToasts = {};
  static const Duration _minDuration = Duration(seconds: 2);

  /// Show a snackbar only if it hasn't been shown recently
  static void showSnackbar(
    BuildContext context, {
    required String message,
    Duration duration = const Duration(seconds: 2),
    SnackBarAction? action,
    bool showOnlyOnce = false,
  }) {
    // Check if we should skip this toast
    if (showOnlyOnce) {
      final lastTime = _lastToasts[message];
      if (lastTime != null &&
          DateTime.now().difference(lastTime) < _minDuration) {
        return; // Skip this toast
      }
      _lastToasts[message] = DateTime.now();
    }

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
          duration: duration,
          action: action,
        ),
      );
  }

  /// Clear all cached toast messages
  static void clearCache() {
    _lastToasts.clear();
  }
}
