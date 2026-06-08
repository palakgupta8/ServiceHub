import 'dart:math';

enum CouponType { percentage, fixedAmount }

class CouponModel {
  final String code;
  final CouponType type;
  final double value;        // 10 = 10% off  |  50 = ₹50 off
  final String? categoryId; // null = all services, 'cleaning' = cleaning only
  final String description;  // shown to user after applying

  const CouponModel({
    required this.code,
    required this.type,
    required this.value,
    this.categoryId,
    required this.description,
  });

  // ── Business logic lives IN the model, not in the UI ──────────────────
  // Why? If discount logic changes, you update ONE place — not every screen

  // Calculate the rupee discount for a given service price
  double discountAmount(double servicePrice) {
    switch (type) {
      case CouponType.percentage:
        return servicePrice * (value / 100);
      case CouponType.fixedAmount:
        // min(): prevent discount from exceeding the service price
        // e.g. ₹50 coupon on ₹30 service → discount = ₹30, not ₹50
        return min(value, servicePrice);
    }
  }

  // Final price after applying coupon
  double finalPrice(double servicePrice) {
    return servicePrice - discountAmount(servicePrice);
  }

  // Human-readable discount label for the price breakdown row
  // e.g. "SAVE10 (-10%)" or "FIRST50 (-₹50)"
  String discountLabel() {
    switch (type) {
      case CouponType.percentage:
        return '$code (-${value.toStringAsFixed(0)}%)';
      case CouponType.fixedAmount:
        return '$code (-₹${value.toStringAsFixed(0)})';
    }
  }
}
