import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/models/service_model.dart';

// Available time slots — in a real app these come from the API
const List<String> _timeSlots = [
  '9:00 AM',  '10:00 AM', '11:00 AM',
  '12:00 PM', '1:00 PM',  '2:00 PM',
  '3:00 PM',  '4:00 PM',  '5:00 PM',
  '6:00 PM',  '7:00 PM',
];

// Mock: slots that are already booked (unavailable)
const List<String> _unavailableSlots = ['10:00 AM', '1:00 PM', '4:00 PM'];

class DateTimeStep extends StatelessWidget {
  final ServiceModel service;
  final DateTime? selectedDate;
  final String? selectedTimeSlot;
  final void Function(DateTime) onDateSelected;
  final void Function(String) onTimeSlotSelected;

  const DateTimeStep({
    super.key,
    required this.service,
    required this.selectedDate,
    required this.selectedTimeSlot,
    required this.onDateSelected,
    required this.onTimeSlotSelected,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Service summary ─────────────────────────────────────────
          _ServiceSummaryCard(service: service),

          const SizedBox(height: 28),

          // ── Date selector ───────────────────────────────────────────
          Text('Select Date', style: AppTextStyles.headingMedium),
          const SizedBox(height: 14),
          _buildDateSelector(),

          const SizedBox(height: 28),

          // ── Time slot selector ──────────────────────────────────────
          Text('Select Time Slot', style: AppTextStyles.headingMedium),
          const SizedBox(height: 6),
          Text(
            'Greyed out slots are already booked',
            style: AppTextStyles.bodySmall,
          ),
          const SizedBox(height: 14),
          _buildTimeSlotGrid(),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    // Generate the next 7 days starting from tomorrow
    final dates = List.generate(
      7,
      (i) => DateTime.now().add(Duration(days: i + 1)),
    );

    return SizedBox(
      height: 76,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: dates.length,
        itemBuilder: (context, index) {
          final date = dates[index];
          final bool isSelected = selectedDate != null &&
              selectedDate!.day == date.day &&
              selectedDate!.month == date.month;

          return GestureDetector(
            onTap: () => onDateSelected(date),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 58,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : Colors.white,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    // DateFormat requires intl package — we format manually
                    _dayName(date.weekday), // Mon, Tue...
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isSelected ? Colors.white70 : AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: AppTextStyles.headingSmall.copyWith(
                      color: isSelected ? Colors.white : AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    _monthName(date.month),
                    style: AppTextStyles.bodySmall.copyWith(
                      color: isSelected ? Colors.white70 : AppColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeSlotGrid() {
    return Wrap(
      // Wrap: like Row but wraps to next line when no space — perfect for chips
      spacing: 10,   // horizontal gap between chips
      runSpacing: 10, // vertical gap between rows
      children: _timeSlots.map((slot) {
        final bool isUnavailable = _unavailableSlots.contains(slot);
        final bool isSelected = selectedTimeSlot == slot;

        return GestureDetector(
          onTap: isUnavailable ? null : () => onTimeSlotSelected(slot),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: isUnavailable
                  ? AppColors.background
                  : isSelected
                      ? AppColors.primary
                      : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isUnavailable
                    ? AppColors.border
                    : isSelected
                        ? AppColors.primary
                        : AppColors.border,
              ),
            ),
            child: Text(
              slot,
              style: AppTextStyles.labelMedium.copyWith(
                color: isUnavailable
                    ? AppColors.textHint
                    : isSelected
                        ? Colors.white
                        : AppColors.textPrimary,
                fontSize: 13,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // Manual day/month formatters — avoids needing the intl package
  String _dayName(int weekday) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[weekday - 1];
  }

  String _monthName(int month) {
    const months = ['Jan','Feb','Mar','Apr','May','Jun',
                    'Jul','Aug','Sep','Oct','Nov','Dec'];
    return months[month - 1];
  }
}

class _ServiceSummaryCard extends StatelessWidget {
  final ServiceModel service;
  const _ServiceSummaryCard({required this.service});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.home_repair_service_rounded,
                color: AppColors.primary, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(service.name, style: AppTextStyles.headingSmall),
                Text(service.categoryName,
                    style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          Text(service.formattedPrice, style: AppTextStyles.price),
        ],
      ),
    );
  }
}
