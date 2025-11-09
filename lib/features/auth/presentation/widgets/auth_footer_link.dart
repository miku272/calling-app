import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

/// A reusable widget for "Already have an account? Login" style links
class AuthFooterLink extends StatelessWidget {
  /// The question text (e.g., "Already have an account?")
  final String questionText;

  /// The action text (e.g., "Login")
  final String actionText;

  /// Callback when action text is tapped
  final VoidCallback onActionTap;

  const AuthFooterLink({
    super.key,
    required this.questionText,
    required this.actionText,
    required this.onActionTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: RichText(
        text: TextSpan(
          text: questionText,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
          children: [
            const TextSpan(text: ' '),
            TextSpan(
              text: actionText,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
              recognizer: TapGestureRecognizer()..onTap = onActionTap,
            ),
          ],
        ),
      ),
    );
  }
}
