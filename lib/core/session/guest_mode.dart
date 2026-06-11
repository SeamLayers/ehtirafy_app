import 'package:shared_preferences/shared_preferences.dart';
import 'package:ehtirafy_app/core/di/service_locator.dart';

/// Tracks whether the user is browsing the app as a guest (no account).
///
/// Guest Mode lets users freely browse non-account features (home, categories,
/// photographers, portfolios) without logging in, per App Store guideline
/// 5.1.1(v). Account-based actions (booking, chat, profile, reviews) still
/// require authentication and are gated through [AuthGuard].
class GuestMode {
  GuestMode._();

  static const String guestKey = 'is_guest_mode';
  static const String _tokenKey = 'cached_token';

  static SharedPreferences? get _prefs {
    if (sl.isRegistered<SharedPreferences>()) {
      return sl<SharedPreferences>();
    }
    return null;
  }

  /// True when a real authentication token is stored.
  static bool get isLoggedIn {
    final token = _prefs?.getString(_tokenKey);
    return token != null && token.isNotEmpty;
  }

  /// A guest is anyone browsing without a valid auth token.
  static bool get isGuest => !isLoggedIn;

  /// Whether the user explicitly chose to continue as a guest (used so the
  /// app resumes at home instead of onboarding on next launch).
  static bool get isActive => _prefs?.getBool(guestKey) ?? false;

  /// Enter guest browsing mode.
  static Future<void> enter() async {
    await _prefs?.setBool(guestKey, true);
  }

  /// Leave guest mode (called on successful login / logout).
  static Future<void> exit() async {
    await _prefs?.setBool(guestKey, false);
  }
}
