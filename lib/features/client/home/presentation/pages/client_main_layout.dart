import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/client_bottom_nav_bar.dart';

class ClientMainLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

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
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }
}
