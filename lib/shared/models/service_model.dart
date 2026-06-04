import 'package:flutter/material.dart';

class ServiceModel {
  final String id;
  final String name;
  final String categoryId;
  final String categoryName;
  final double price;
  final double rating;
  final int reviewCount;
  final int durationMinutes; // how long the service takes
  final String description;
  final Color cardColor;     // placeholder color until we have real images

  const ServiceModel({
    required this.id,
    required this.name,
    required this.categoryId,
    required this.categoryName,
    required this.price,
    required this.rating,
    required this.reviewCount,
    required this.durationMinutes,
    required this.description,
    required this.cardColor,
  });

  // Helper: formats review count for display
  // 1100 → "1.1k"  |  890 → "890"
  String get formattedReviews {
    if (reviewCount >= 1000) {
      return '${(reviewCount / 1000).toStringAsFixed(1)}k';
    }
    return reviewCount.toString();
  }

  // Helper: formats price with ₹ symbol
  String get formattedPrice => '₹${price.toStringAsFixed(0)}';
}
