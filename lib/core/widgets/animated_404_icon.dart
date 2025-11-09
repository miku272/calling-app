import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

class Animated404Icon extends StatefulWidget {
  final double size;
  final Color? color;

  const Animated404Icon({super.key, this.size = 120, this.color});

  @override
  State<Animated404Icon> createState() => _Animated404IconState();
}

class _Animated404IconState extends State<Animated404Icon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _scaleAnimation = Tween<double>(
      begin: 0.95,
      end: 1.05,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final iconColor =
        widget.color ??
        (theme.brightness == Brightness.light
            ? AppColors.onSurfaceVariant.withValues(alpha: 0.5)
            : AppColors.darkOnSurfaceVariant.withValues(alpha: 0.5));

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(scale: _scaleAnimation.value, child: child);
      },
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(painter: _NotFoundIconPainter(color: iconColor)),
      ),
    );
  }
}

class _NotFoundIconPainter extends CustomPainter {
  final Color color;

  _NotFoundIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.width * 0.08
      ..strokeCap = StrokeCap.round;

    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width * 0.4;

    canvas.drawCircle(center, radius, paint);

    final handleStart = Offset(
      center.dx + radius * 0.7,
      center.dy + radius * 0.7,
    );
    final handleEnd = Offset(
      center.dx + radius * 1.2,
      center.dy + radius * 1.2,
    );
    canvas.drawLine(handleStart, handleEnd, paint);

    final textPainter = TextPainter(
      text: TextSpan(
        text: '404',
        style: TextStyle(
          color: color,
          fontSize: size.width * 0.25,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(_NotFoundIconPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}
