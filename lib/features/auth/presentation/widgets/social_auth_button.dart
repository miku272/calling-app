import 'package:flutter/material.dart';

/// A reusable widget for social authentication buttons (Google, Apple, etc.)
class SocialAuthButton extends StatelessWidget {
  /// The social provider name
  final String provider;

  /// The icon to display
  final IconData icon;

  /// Callback when pressed
  final VoidCallback onPressed;

  /// Custom background color
  final Color? backgroundColor;

  /// Custom icon color
  final Color? iconColor;

  const SocialAuthButton({
    super.key,
    required this.provider,
    required this.icon,
    required this.onPressed,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return OutlinedButton.icon(
      onPressed: onPressed,
      icon: Icon(
        icon,
        color: iconColor ?? theme.colorScheme.onSurface,
        size: 24,
      ),
      label: Text(provider, style: const TextStyle(fontSize: 20)),
      style: OutlinedButton.styleFrom(
        backgroundColor: backgroundColor,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        side: BorderSide(
          color: isDark ? const Color(0xFF3A3A3C) : const Color(0xFFE5E5EA),
          width: 1.5,
        ),
      ),
    );
  }
}
