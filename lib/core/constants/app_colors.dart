import 'package:flutter/material.dart';

class AppColors {
  // ===== Primary Brand Colors =====
  static const Color primary = Color(0xFF0A84FF); // main blue
  static const Color secondary = Color(0xFF30D158); // green accent

  // ===== Surface & Background =====
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceContainer = Color(
    0xFFF5F7FA,
  ); // light gray background

  // ===== Text Colors =====
  static const Color onSurface = Color(0xFF1C1C1E); // main text
  static const Color onSurfaceVariant = Color(0xFF6E6E73); // secondary text

  // ===== Status Colors =====
  static const Color success = Color(0xFF34C759);
  static const Color error = Color(0xFFFF3B30);
  static const Color warning = Color(0xFFFFCC00);
  static const Color info = Color(0xFF5AC8FA);

  // ===== Gradients =====
  static const List<Color> callActiveGradient = [
    Color(0xFF0A84FF),
    Color(0xFF30D158),
  ];

  // ===== Dark Mode =====
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkSurfaceContainer = Color(0xFF121212);
  static const Color darkOnSurface = Color(0xFFFFFFFF);
  static const Color darkOnSurfaceVariant = Color(0xFFB3B3B3);
}
