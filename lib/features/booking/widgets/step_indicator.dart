import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class StepIndicator extends StatelessWidget {
  final int currentStep; // 0-based: 0, 1, 2, or 3
  final int totalSteps;

  const StepIndicator({
    super.key,
    required this.currentStep,
    required this.totalSteps,
  });

  static const _labels = ['Date & Time', 'Address', 'Review', 'Payment'];

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List.generate(totalSteps * 2 - 1, (index) {
        // The list alternates: circle, line, circle, line, circle
        // Odd indices = connecting lines, Even indices = step circles
        if (index.isOdd) {
          return _buildLine(index ~/ 2); // integer division gives step index
        } else {
          final step = index ~/ 2;
          return _buildStep(step);
        }
      }),
    );
  }

  Widget _buildStep(int step) {
    final bool isCompleted = step < currentStep;
    final bool isActive = step == currentStep;

    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: (isCompleted || isActive) ? AppColors.primary : Colors.white,
            border: Border.all(
              color: (isCompleted || isActive)
                  ? AppColors.primary
                  : AppColors.border,
              width: 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check_rounded, size: 16, color: Colors.white)
                : Text(
                    '${step + 1}',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isActive ? Colors.white : AppColors.textHint,
                    ),
                  ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          _labels[step],
          style: AppTextStyles.bodySmall.copyWith(
            color: (isCompleted || isActive)
                ? AppColors.primary
                : AppColors.textHint,
            fontWeight:
                isActive ? FontWeight.w600 : FontWeight.w400,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  // The line connecting two step circles
  Widget _buildLine(int stepBefore) {
    final bool isCompleted = stepBefore < currentStep;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 20),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          height: 2,
          color: isCompleted ? AppColors.primary : AppColors.border,
        ),
      ),
    );
  }
}
