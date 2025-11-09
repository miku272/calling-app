import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// A reusable header widget for authentication screens with logo and title
class AuthHeader extends StatelessWidget {
  /// Title text
  final String title;

  /// Subtitle text
  final String subtitle;

  /// Whether to show a logo/icon
  final bool showLogo;

  /// Custom logo widget
  final Widget? logo;

  const AuthHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.showLogo = true,
    this.logo,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Logo section
        if (showLogo) ...[
          Center(
            child:
                logo ??
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.phone_in_talk_rounded,
                    size: 40,
                    color: AppColors.primary,
                  ),
                ),
          ),
          const SizedBox(height: 32),
        ],

        // Title
        Text(
          title,
          style: theme.textTheme.headlineMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        const SizedBox(height: 8),

        // Subtitle
        Text(
          subtitle,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ],
    );
  }
}
