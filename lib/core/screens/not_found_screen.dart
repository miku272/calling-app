import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/animated_404_icon.dart';

class NotFoundScreen extends StatelessWidget {
  final String? title;
  final String? message;
  final String? actionText;
  final VoidCallback? onActionPressed;
  final bool showBackButton;

  const NotFoundScreen({
    super.key,
    this.title,
    this.message,
    this.actionText,
    this.onActionPressed,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canPop = Navigator.of(context).canPop();

    return Scaffold(
      appBar: AppBar(automaticallyImplyLeading: showBackButton && canPop),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Animated404Icon(size: 180),
                const SizedBox(height: 48),

                Text(
                  title ?? 'Page Not Found',
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    message ??
                        'Oops! The page you\'re looking for doesn\'t exist.\nIt might have been moved or deleted.',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.6,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 48),

                _buildActionButtons(context, canPop),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, bool canPop) {
    return Column(
      children: [
        ElevatedButton.icon(
          onPressed: () {
            if (onActionPressed != null) {
              onActionPressed!();
            } else if (canPop) {
              context.pop();
            } else {
              context.go('/');
            }
          },
          icon: Icon(canPop ? Icons.arrow_back_rounded : Icons.home_rounded),
          label: Text(actionText ?? (canPop ? 'Go Back' : 'Go to Home')),
        ),

        if (canPop && onActionPressed == null) ...[
          const SizedBox(height: 16),
          OutlinedButton.icon(
            onPressed: () {
              context.go('/');
            },
            icon: const Icon(Icons.home_rounded),
            label: const Text('Go to Home'),
          ),
        ],
      ],
    );
  }
}
