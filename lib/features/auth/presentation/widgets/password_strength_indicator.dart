import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';

/// A widget that displays password strength indicator with smooth animations
class PasswordStrengthIndicator extends StatefulWidget {
  /// The password to evaluate
  final String password;

  /// Whether to show the indicator
  final bool show;

  const PasswordStrengthIndicator({
    super.key,
    required this.password,
    this.show = true,
  });

  @override
  State<PasswordStrengthIndicator> createState() =>
      _PasswordStrengthIndicatorState();
}

class _PasswordStrengthIndicatorState extends State<PasswordStrengthIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _heightAnimation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _heightAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );

    _opacityAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeIn,
    );

    if (widget.show && widget.password.isNotEmpty) {
      _controller.forward();
    }
  }

  @override
  void didUpdateWidget(PasswordStrengthIndicator oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.show && widget.password.isNotEmpty) {
      _controller.forward();
    } else {
      _controller.reverse();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Calculate password strength (0-4)
  int _calculateStrength() {
    if (widget.password.isEmpty) return 0;

    int strength = 0;

    // Length check
    if (widget.password.length >= 8) strength++;
    if (widget.password.length >= 12) strength++;

    // Character variety checks
    if (RegExp(r'[A-Z]').hasMatch(widget.password)) strength++;
    if (RegExp(r'[a-z]').hasMatch(widget.password)) strength++;
    if (RegExp(r'[0-9]').hasMatch(widget.password)) strength++;
    if (RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(widget.password)) strength++;

    // Cap at 4
    return (strength / 1.5).clamp(0, 4).round();
  }

  String _getStrengthLabel(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return 'Weak';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Strong';
      default:
        return '';
    }
  }

  Color _getStrengthColor(int strength) {
    switch (strength) {
      case 0:
      case 1:
        return AppColors.error;
      case 2:
        return AppColors.warning;
      case 3:
        return AppColors.info;
      case 4:
        return AppColors.success;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final strength = _calculateStrength();
    final label = _getStrengthLabel(strength);
    final color = _getStrengthColor(strength);

    return SizeTransition(
      sizeFactor: _heightAnimation,
      axisAlignment: -1,
      child: FadeTransition(
        opacity: _opacityAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: Row(
                    children: List.generate(4, (index) {
                      return Expanded(
                        child: TweenAnimationBuilder<double>(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeOutCubic,
                          tween: Tween<double>(
                            begin: 0,
                            end: index < strength ? 1.0 : 0.3,
                          ),
                          builder: (context, value, child) {
                            return Container(
                              height: 4,
                              margin: EdgeInsets.only(right: index < 3 ? 4 : 0),
                              decoration: BoxDecoration(
                                color: index < strength
                                    ? color.withValues(alpha: value)
                                    : theme.colorScheme.outline.withValues(
                                        alpha: 0.3,
                                      ),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            );
                          },
                        ),
                      );
                    }),
                  ),
                ),
                const SizedBox(width: 12),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  transitionBuilder: (child, animation) {
                    return FadeTransition(
                      opacity: animation,
                      child: ScaleTransition(scale: animation, child: child),
                    );
                  },
                  child: Text(
                    label,
                    key: ValueKey(label),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: color,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
