import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/constants/app_constants.dart';
import '../../../shared/models/service_model.dart';
import 'address_step.dart';

class ReviewStep extends StatelessWidget {
  final ServiceModel service;
  final DateTime selectedDate;
  final String selectedTimeSlot;
  final String name;
  final String phone;
  final String address;
  final String city;
  final String pincode;
  final AddressType addressType;

  const ReviewStep({
    super.key,
    required this.service,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.name,
    required this.phone,
    required this.address,
    required this.city,
    required this.pincode,
    required this.addressType,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Booking Summary', style: AppTextStyles.headingMedium),
          const SizedBox(height: 6),
          Text('Please review before confirming',
              style: AppTextStyles.bodySmall),

          const SizedBox(height: 20),

          // ── Service details ─────────────────────────────────────────
          _SummaryCard(
            icon: Icons.home_repair_service_rounded,
            iconColor: AppColors.primary,
            iconBg: AppColors.primaryLight,
            title: 'Service',
            rows: [
              _Row('Name', service.name),
              _Row('Category', service.categoryName),
              _Row('Duration', '${service.durationMinutes} minutes'),
            ],
          ),

          const SizedBox(height: 14),

          // ── Schedule ────────────────────────────────────────────────
          _SummaryCard(
            icon: Icons.calendar_month_rounded,
            iconColor: const Color(0xFF2DD36F),
            iconBg: const Color(0xFFF0FFF4),
            title: 'Schedule',
            rows: [
              _Row('Date', _formatDate(selectedDate)),
              _Row('Time', selectedTimeSlot),
            ],
          ),

          const SizedBox(height: 14),

          // ── Address ──────────────────────────────────────────────────
          _SummaryCard(
            icon: Icons.location_on_rounded,
            iconColor: const Color(0xFFFF6B6B),
            iconBg: const Color(0xFFFFF0F0),
            title: 'Address',
            rows: [
              _Row('Name', name),
              _Row('Phone', phone),
              _Row('Address', '$address, $city - $pincode'),
              _Row('Type', addressType.name[0].toUpperCase() +
                  addressType.name.substring(1)),
            ],
          ),

          const SizedBox(height: 14),

          // ── Price breakdown ──────────────────────────────────────────
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.border),
            ),
            child: Column(
              children: [
                _priceRow('Service Charge', service.formattedPrice),
                const SizedBox(height: 10),
                _priceRow('Platform Fee', '₹0'),
                const SizedBox(height: 10),
                const Divider(),
                const SizedBox(height: 10),
                _priceRow(
                  'Total Amount',
                  service.formattedPrice,
                  isTotal: true,
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Cancellation note
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFFBE6),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.warning.withValues(alpha: 0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.info_outline_rounded,
                    size: 16, color: AppColors.warning),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Free cancellation up to 2 hours before the scheduled time.',
                    style: AppTextStyles.bodySmall.copyWith(
                        color: AppColors.textPrimary),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _priceRow(String label, String value, {bool isTotal = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: isTotal
              ? AppTextStyles.headingSmall
              : AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: isTotal
              ? AppTextStyles.price
              : AppTextStyles.bodyMedium,
        ),
      ],
    );
  }

  String _formatDate(DateTime date) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    return '${days[date.weekday - 1]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }
}

// ── Reusable summary card ────────────────────────────────────────────────────
class _SummaryCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final Color iconBg;
  final String title;
  final List<_Row> rows;

  const _SummaryCard({
    required this.icon,
    required this.iconColor,
    required this.iconBg,
    required this.title,
    required this.rows,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                    color: iconBg, shape: BoxShape.circle),
                child: Icon(icon, size: 16, color: iconColor),
              ),
              const SizedBox(width: 10),
              Text(title, style: AppTextStyles.headingSmall),
            ],
          ),
          const SizedBox(height: 12),
          ...rows.map((r) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 80,
                      child: Text(r.label,
                          style: AppTextStyles.bodySmall),
                    ),
                    Expanded(
                      child: Text(r.value,
                          style: AppTextStyles.bodyMedium.copyWith(
                              fontWeight: FontWeight.w500)),
                    ),
                  ],
                ),
              )),
        ],
      ),
    );
  }
}

class _Row {
  final String label;
  final String value;
  const _Row(this.label, this.value);
}
