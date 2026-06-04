import 'package:flutter/material.dart';

class OnboardingModel {
  final String title;
  final String description;
  final IconData icon;
  final Color illustrationBg; // colored top section background
  final Color iconColor;

  const OnboardingModel({
    required this.title,
    required this.description,
    required this.icon,
    required this.illustrationBg,
    required this.iconColor,
  });
}

final List<OnboardingModel> onboardingPages = List.unmodifiable([
  const OnboardingModel(
    title: 'Find Trusted Services',
    description:
        'Discover professional home services including cleaning, plumbing, electrical repairs, and more.',
    icon: Icons.home_repair_service_rounded,
    illustrationBg: Color(0xFF4F6AF5),
    iconColor: Color(0xFF4F6AF5),
  ),
  const OnboardingModel(
    title: 'Easy Booking',
    description:
        'Select your preferred service, choose a convenient time slot, and book in just a few taps.',
    icon: Icons.calendar_month_rounded,
    illustrationBg: Color(0xFFFF6B6B),
    iconColor: Color(0xFFFF6B6B),
  ),
  const OnboardingModel(
    title: 'Track Your Requests',
    description:
        'Stay updated with booking status and manage all your service requests from one place.',
    icon: Icons.track_changes_rounded,
    illustrationBg: Color(0xFF2DD36F),
    iconColor: Color(0xFF2DD36F),
  ),
]);
