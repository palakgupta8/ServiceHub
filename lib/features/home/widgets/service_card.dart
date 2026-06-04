import 'package:flutter/material.dart';
import '../../../shared/models/service_model.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';

class ServiceCard extends StatelessWidget {
  final ServiceModel service;
  final VoidCallback onTap;

  const ServiceCard({
    super.key,
    required this.service,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
          border: Border.all(color: AppColors.border),
          // Subtle shadow — lifts the card off the background
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            // ── Colored image placeholder ─────────────────────────────
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: service.cardColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(AppConstants.radiusL),
                  bottomLeft: Radius.circular(AppConstants.radiusL),
                ),
              ),
              child: Center(
                child: Icon(
                  _iconForCategory(service.categoryId),
                  size: 44,
                  color: _iconColorForCategory(service.categoryId),
                ),
              ),
            ),

            // ── Service info ──────────────────────────────────────────
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Category chip
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: service.cardColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        service.categoryName,
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                      ),
                    ),

                    const SizedBox(height: 6),

                    // Service name
                    Text(
                      service.name,
                      style: AppTextStyles.headingSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 6),

                    // Rating + reviews
                    Row(
                      children: [
                        const Icon(Icons.star_rounded,
                            size: 14, color: AppColors.star),
                        const SizedBox(width: 3),
                        Text(
                          service.rating.toStringAsFixed(1),
                          style: AppTextStyles.bodySmall.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          '  (${service.formattedReviews})',
                          style: AppTextStyles.bodySmall,
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.access_time_rounded,
                            size: 12, color: AppColors.textSecondary),
                        const SizedBox(width: 3),
                        Text(
                          '${service.durationMinutes} min',
                          style: AppTextStyles.bodySmall,
                        ),
                      ],
                    ),

                    const SizedBox(height: 8),

                    // Price + Book button
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          service.formattedPrice,
                          style: AppTextStyles.price,
                        ),
                        TextButton(
                          onPressed: onTap,
                          style: TextButton.styleFrom(
                            backgroundColor: AppColors.primaryLight,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 4),
                            minimumSize: Size.zero,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(
                            'Book',
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Maps category ID → matching icon
  IconData _iconForCategory(String categoryId) {
    const map = {
      'cleaning': Icons.cleaning_services_rounded,
      'plumbing': Icons.plumbing_rounded,
      'electrical': Icons.electrical_services_rounded,
      'beauty': Icons.spa_rounded,
      'painting': Icons.format_paint_rounded,
      'ac_repair': Icons.ac_unit_rounded,
      'carpentry': Icons.handyman_rounded,
      'pest_control': Icons.pest_control_rounded,
    };
    return map[categoryId] ?? Icons.home_repair_service_rounded;
  }

  Color _iconColorForCategory(String categoryId) {
    const map = {
      'cleaning': Color(0xFF4F6AF5),
      'plumbing': Color(0xFFFF6B6B),
      'electrical': Color(0xFFFFB822),
      'beauty': Color(0xFFE91E8C),
      'painting': Color(0xFF7C4DFF),
      'ac_repair': Color(0xFF00BCD4),
      'carpentry': Color(0xFFFF9800),
      'pest_control': Color(0xFF2DD36F),
    };
    return map[categoryId] ?? const Color(0xFF4F6AF5);
  }
}
