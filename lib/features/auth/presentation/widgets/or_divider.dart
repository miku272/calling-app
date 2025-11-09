import 'package:flutter/material.dart';

/// A divider widget with centered text (e.g., "OR")
class OrDivider extends StatelessWidget {
  /// The text to display in the center
  final String text;

  const OrDivider({super.key, this.text = 'OR'});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        const Expanded(child: Divider()),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            text,
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        const Expanded(child: Divider()),
      ],
    );
  }
}
