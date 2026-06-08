import 'package:flutter/material.dart';

// Single source of truth for category icons and colors
// Previously duplicated in service_card.dart and service_detail_screen.dart
class CategoryUtils {
  CategoryUtils._();

  static IconData iconFor(String categoryId) {
    const map = {
      'cleaning':     Icons.cleaning_services_rounded,
      'plumbing':     Icons.plumbing_rounded,
      'electrical':   Icons.electrical_services_rounded,
      'beauty':       Icons.spa_rounded,
      'painting':     Icons.format_paint_rounded,
      'ac_repair':    Icons.ac_unit_rounded,
      'carpentry':    Icons.handyman_rounded,
      'pest_control': Icons.pest_control_rounded,
    };
    return map[categoryId] ?? Icons.home_repair_service_rounded;
  }

  static Color colorFor(String categoryId) {
    const map = {
      'cleaning':     Color(0xFF4F6AF5),
      'plumbing':     Color(0xFFFF6B6B),
      'electrical':   Color(0xFFFFB822),
      'beauty':       Color(0xFFE91E8C),
      'painting':     Color(0xFF7C4DFF),
      'ac_repair':    Color(0xFF00BCD4),
      'carpentry':    Color(0xFFFF9800),
      'pest_control': Color(0xFF2DD36F),
    };
    return map[categoryId] ?? const Color(0xFF4F6AF5);
  }
}
