import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:ehtirafy_app/core/session/auth_guard.dart';
import 'package:ehtirafy_app/core/session/guest_mode.dart';
import '../widgets/client_bottom_nav_bar.dart';

class ClientMainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  // Account-based tabs that require login: 1 (Messages) and 2 (My Requests).
  // Home (3) and Profile (0) stay open to guests — the Profile screen shows
  // settings/privacy plus a "login now" card instead of account data.
  static const Set<int> _accountTabs = {1, 2};

  const ClientMainLayout({super.key, required this.navigationShell});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: ClientBottomNavBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (index) => _onTap(context, index),
      ),
    );
  }

  void _onTap(BuildContext context, int index) {
    // Guests can browse Home and open Profile (settings/privacy), but
    // account-based tabs (Messages, My Requests) require login.
    if (GuestMode.isGuest && _accountTabs.contains(index)) {
      AuthGuard.showLoginRequiredSheet(context);
      return;
    }
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
