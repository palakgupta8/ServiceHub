import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand colors
  static const Color primary = Color(0xFF4F6AF5);
  static const Color primaryLight = Color(0xFFEEF1FF);
  static const Color secondary = Color(0xFFFF6B6B);

  // Background
  static const Color background = Color(0xFFF8F9FE);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color cardBackground = Color(0xFFFFFFFF);

  // Text
  static const Color textPrimary = Color(0xFF1A1D3B);
  static const Color textSecondary = Color(0xFF8A94A6);
  static const Color textHint = Color(0xFFB8BEC7);

  // Status
  static const Color success = Color(0xFF2DD36F);
  static const Color warning = Color(0xFFFFB822);
  static const Color error = Color(0xFFEB445A);

  // Border & divider
  static const Color border = Color(0xFFE8ECF4);
  static const Color divider = Color(0xFFF0F3F9);

  // Star rating
  static const Color star = Color(0xFFFFB822);

  // Category card colors (used for service category backgrounds)
  static const List<Color> categoryColors = [
    Color(0xFFEEF1FF),
    Color(0xFFFFF0F0),
    Color(0xFFF0FFF4),
    Color(0xFFFFFBE6),
    Color(0xFFF3F0FF),
    Color(0xFFE6F9FF),
  ];
}
