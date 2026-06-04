import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class DotsIndicator extends StatelessWidget {
  final int totalDots;   // how many dots to draw (= number of pages)
  final int currentIndex; // which dot is active right now

  const DotsIndicator({
    super.key,
    required this.totalDots,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min, // Row only as wide as its dots
      children: List.generate(
        totalDots,
        // List.generate(count, builder) creates a list of [count] items
        // index goes 0, 1, 2... for each dot
        (index) => _buildDot(index),
      ),
    );
  }

  Widget _buildDot(int index) {
    final bool isActive = index == currentIndex;

    return AnimatedContainer(
      // AnimatedContainer: whenever width/color/decoration changes,
      // Flutter automatically animates the transition — no manual animation needed!
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
      margin: const EdgeInsets.symmetric(horizontal: 4),
      width: isActive ? 24 : 8,   // active dot = wide pill, inactive = small circle
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primary : AppColors.border,
        borderRadius: BorderRadius.circular(4), // round ends = pill shape
      ),
    );
  }
}
