import 'package:flutter/material.dart';

// enum: a fixed set of named values
// Better than using raw strings like 'completed', 'upcoming'
// because the compiler catches typos at build time
enum BookingStatus { upcoming, completed, cancelled }

class BookingModel {
  final String id;
  final String serviceId;
  final String serviceName;
  final String categoryName;
  final String date;
  final String timeSlot;
  final String address;
  final double price;
  final BookingStatus status;

  const BookingModel({
    required this.id,
    required this.serviceId,
    required this.serviceName,
    required this.categoryName,
    required this.date,
    required this.timeSlot,
    required this.address,
    required this.price,
    required this.status,
  });

  String get formattedPrice => '₹${price.toStringAsFixed(0)}';

  // Label shown on the status chip
  String get statusLabel {
    switch (status) {
      case BookingStatus.upcoming:   return 'Upcoming';
      case BookingStatus.completed:  return 'Completed';
      case BookingStatus.cancelled:  return 'Cancelled';
    }
  }

  // Color for each status chip
  Color get statusColor {
    switch (status) {
      case BookingStatus.upcoming:   return const Color(0xFF4F6AF5);
      case BookingStatus.completed:  return const Color(0xFF2DD36F);
      case BookingStatus.cancelled:  return const Color(0xFFEB445A);
    }
  }

  Color get statusBgColor {
    switch (status) {
      case BookingStatus.upcoming:   return const Color(0xFFEEF1FF);
      case BookingStatus.completed:  return const Color(0xFFF0FFF4);
      case BookingStatus.cancelled:  return const Color(0xFFFFF0F0);
    }
  }
}
