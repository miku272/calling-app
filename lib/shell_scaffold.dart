import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/widgets/app_bottom_navigation_bar.dart';

class ShellScaffold extends StatelessWidget {
  final Widget child;
  final GoRouterState state;

  const ShellScaffold({super.key, required this.child, required this.state});

  int _getSelectedIndex(String location) {
    if (location.startsWith('/calls')) return 1;
    if (location.startsWith('/people')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  void _onDestinationSelected(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go('/');
        break;
      case 1:
        context.go('/calls');
        break;
      case 2:
        context.go('/people');
        break;
      case 3:
        context.go('/settings');
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _getSelectedIndex(state.uri.path);

    return Scaffold(
      body: child,
      bottomNavigationBar: AppBottomNavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) =>
            _onDestinationSelected(context, index),
      ),
    );
  }
}
