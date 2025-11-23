import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'core/widgets/app_bottom_navigation_bar.dart';

/// A scaffold wrapper for shell routes that provides bottom navigation.
///
/// This widget wraps authenticated screens and provides a consistent
/// bottom navigation bar across multiple routes. It's used with GoRouter's
/// ShellRoute to maintain navigation state while switching between screens.
///
/// The scaffold automatically determines which navigation item should be
/// selected based on the current route path.
class ShellScaffold extends StatelessWidget {
  /// The child widget to display in the body.
  final Widget child;

  /// The current router state, used to determine the selected navigation item.
  final GoRouterState state;

  const ShellScaffold({super.key, required this.child, required this.state});

  /// Determines which navigation item should be selected based on the route.
  ///
  /// Maps route paths to navigation indices:
  /// - `/` → 0 (Home)
  /// - `/calls` → 1 (Calls)
  /// - `/people` → 2 (People)
  /// - `/settings` → 3 (Settings)
  ///
  /// Returns 0 (Home) as the default if no match is found.
  int _getSelectedIndex(String location) {
    if (location.startsWith('/calls')) return 1;
    if (location.startsWith('/people')) return 2;
    if (location.startsWith('/settings')) return 3;
    return 0;
  }

  /// Handles navigation when a bottom navigation item is tapped.
  ///
  /// Navigates to the corresponding route based on the selected index:
  /// - 0 → Home (`/`)
  /// - 1 → Calls (`/calls`)
  /// - 2 → People (`/people`)
  /// - 3 → Settings (`/settings`)
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
