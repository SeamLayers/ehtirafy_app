import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';
import '../entities/user_role.dart';

/// Centralized service for managing user role state
/// This ensures consistent role management across the entire app
abstract class RoleService {
  /// Get current stored role
  Future<UserRole> getCurrentRole();

  /// Switch to a different role
  Future<void> switchRole(UserRole newRole);

  /// Clear role (logout)
  Future<void> clearRole();

  /// Stream of role changes
  Stream<UserRole> getRoleStream();
}

/// Implementation using SharedPreferences
class RoleServiceImpl implements RoleService {
  final SharedPreferences _prefs;
  static const String _roleKey = 'user_role';

  /// Internal stream controller for broadcasting role changes
  static final _roleStreamController = _RoleStreamController();

  RoleServiceImpl(this._prefs);

  @override
  Future<UserRole> getCurrentRole() async {
    final roleString = _prefs.getString(_roleKey);
    if (roleString == null) {
      return UserRole.client; // Default role
    }
    try {
      return UserRole.values.firstWhere((e) => e.name == roleString);
    } catch (e) {
      return UserRole.client;
    }
  }

  @override
  Future<void> switchRole(UserRole newRole) async {
    await _prefs.setString(_roleKey, newRole.name);
    _roleStreamController.add(newRole);
  }

  @override
  Future<void> clearRole() async {
    await _prefs.remove(_roleKey);
    _roleStreamController.add(UserRole.client);
  }

  @override
  Stream<UserRole> getRoleStream() => _roleStreamController.stream;
}

/// Stream controller for role changes
class _RoleStreamController {
  final List<Function(UserRole)> _listeners = [];
  UserRole? _lastRole;

  void add(UserRole role) {
    _lastRole = role;
    for (var listener in _listeners) {
      listener(role);
    }
  }

  Stream<UserRole> get stream {
    return Stream.fromIterable([
      if (_lastRole != null) _lastRole!,
    ]).asBroadcastStream().transform(
      StreamTransformer.fromHandlers(
        handleData: (data, sink) => sink.add(data),
      ),
    );
  }
}
