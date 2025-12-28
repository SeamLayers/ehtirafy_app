import 'dart:async';
import 'package:flutter/foundation.dart';

/// A ChangeNotifier that wraps a Stream and notifies listeners on stream events.
///
/// Used for GoRouter's refreshListenable to refresh the router when stream emits.
/// NOTE: We do NOT call notifyListeners() immediately in constructor to avoid
/// triggering router rebuilds before the app is ready.
class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen(
      (dynamic _) => notifyListeners(),
    );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
