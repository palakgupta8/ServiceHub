import 'package:flutter/material.dart';
import '../../../shared/models/onboarding_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';

class OnboardingPage extends StatelessWidget {
  final OnboardingModel page;

  const OnboardingPage({super.key, required this.page});

  @override
  Widget build(BuildContext context) {
    // MediaQuery gives us the screen dimensions
    // We use it to make the illustration section proportional to any screen size
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        // ── Illustration section (colored top area) ──────────────────────
        Container(
          height: screenHeight * 0.42, // 42% of screen height
          width: double.infinity,
          decoration: BoxDecoration(
            color: page.illustrationBg,
            // Only round the bottom corners — top stays flush with screen edge
            borderRadius: const BorderRadius.only(
              bottomLeft: Radius.circular(40),
              bottomRight: Radius.circular(40),
            ),
          ),
          child: Center(
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                // Shadow makes the white circle "float" on the colored background
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 30,
                    offset: const Offset(0, 12),
                  ),
                ],
              ),
              child: Icon(
                page.icon,
                size: 72,
                color: page.iconColor,
              ),
            ),
          ),
        ),

        // ── Text content (white area below) ──────────────────────────────
        Expanded(
          // Expanded fills the remaining vertical space after the illustration
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              // crossAxisAlignment.start = align children to the left
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),

                Text(
                  page.title,
                  style: AppTextStyles.displayMedium,
                ),

                const SizedBox(height: 16),

                Text(
                  page.description,
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6, // line height — makes multi-line text breathe
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
