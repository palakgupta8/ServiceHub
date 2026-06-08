import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../shared/data/mock_data.dart';
import '../../shared/models/booking_model.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../profile/widgets/booking_history_card.dart';

class BookingsTab extends StatefulWidget {
  const BookingsTab({super.key});

  @override
  State<BookingsTab> createState() => _BookingsTabState();
}

class _BookingsTabState extends State<BookingsTab> {
  // null = show all bookings, otherwise filter by this status
  BookingStatus? _selectedFilter;

  List<BookingModel> get _filteredBookings {
    if (_selectedFilter == null) return MockData.myBookings;
    return MockData.myBookings
        .where((b) => b.status == _selectedFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final bookings = _filteredBookings;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            floating: true,
            snap: true,
            backgroundColor: AppColors.background,
            automaticallyImplyLeading: false,
            title: Text('My Bookings', style: AppTextStyles.headingMedium),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(52),
              child: _buildFilterChips(),
            ),
          ),

          SliverToBoxAdapter(
            child: bookings.isEmpty
                ? _buildEmptyState()
                : Padding(
                    padding: const EdgeInsets.all(AppConstants.paddingM),
                    child: Column(
                      children: bookings.map((b) {
                        return BookingHistoryCard(
                          booking: b,
                          // Completed bookings open the rating modal on tap
                          onTap: b.status == BookingStatus.completed
                              ? () => _showRatingModal(context, b)
                              : null,
                        );
                      }).toList(),
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips() {
    // Filter options: null = All, then each BookingStatus value
    final filters = <BookingStatus?>[null, ...BookingStatus.values];

    return SizedBox(
      height: 52,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
        itemCount: filters.length,
        itemBuilder: (context, index) {
          final filter = filters[index];
          final bool isSelected = _selectedFilter == filter;
          final label = filter == null ? 'All' : _labelFor(filter);
          final color = filter == null ? AppColors.primary : _colorFor(filter);

          return GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              setState(() => _selectedFilter = filter);
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: isSelected ? color : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? color : AppColors.border,
                ),
              ),
              child: Center(
                child: Text(
                  label,
                  style: AppTextStyles.labelSmall.copyWith(
                    color: isSelected ? Colors.white : AppColors.textSecondary,
                    fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    // Show contextual messaging based on which filter is active
    final (icon, iconColor, iconBg, title, subtitle) =
        switch (_selectedFilter) {
      BookingStatus.upcoming => (
          Icons.event_busy_outlined,
          AppColors.primary,
          AppColors.primaryLight,
          'No upcoming bookings',
          'Book a service and it will appear here',
        ),
      BookingStatus.completed => (
          Icons.check_circle_outline_rounded,
          AppColors.success,
          const Color(0xFFF0FFF4),
          'No completed bookings',
          'Your completed services will show up here',
        ),
      BookingStatus.cancelled => (
          Icons.cancel_outlined,
          AppColors.error,
          const Color(0xFFFFF0F0),
          'No cancelled bookings',
          "You haven't cancelled any bookings",
        ),
      null => (
          Icons.calendar_today_outlined,
          AppColors.primary,
          AppColors.primaryLight,
          'No bookings yet',
          'Book a service to get started',
        ),
    };

    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: iconBg,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 36, color: iconColor),
            ),
            const SizedBox(height: 20),
            Text(title, style: AppTextStyles.headingSmall),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ── Rating modal ─────────────────────────────────────────────────────────
  void _showRatingModal(BuildContext context, BookingModel booking) {
    int rating = 0;
    final commentController = TextEditingController();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => StatefulBuilder(
        builder: (_, setModalState) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 24,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 32,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Handle bar
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.border,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 20),

              Text('Rate Your Experience',
                  style: AppTextStyles.headingMedium),
              const SizedBox(height: 6),
              Text(booking.serviceName,
                  style: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textSecondary)),
              const SizedBox(height: 24),

              // Star selector
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (i) {
                  return GestureDetector(
                    onTap: () {
                      HapticFeedback.selectionClick();
                      setModalState(() => rating = i + 1);
                    },
                    child: Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 6),
                      child: Icon(
                        i < rating
                            ? Icons.star_rounded
                            : Icons.star_border_rounded,
                        size: 44,
                        color: AppColors.star,
                      ),
                    ),
                  );
                }),
              ),
              const SizedBox(height: 20),

              // Comment field
              TextField(
                controller: commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'Share your experience (optional)',
                  hintStyle: AppTextStyles.bodySmall
                      .copyWith(color: AppColors.textHint),
                  contentPadding: const EdgeInsets.all(14),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Submit button — disabled until a star is selected
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: rating == 0
                      ? null
                      : () {
                          Navigator.pop(ctx);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text(
                                  'Thank you for your feedback!'),
                              backgroundColor: AppColors.success,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          );
                        },
                  child: const Text('Submit Review'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _labelFor(BookingStatus status) {
    switch (status) {
      case BookingStatus.upcoming:  return 'Upcoming';
      case BookingStatus.completed: return 'Completed';
      case BookingStatus.cancelled: return 'Cancelled';
    }
  }

  Color _colorFor(BookingStatus status) {
    switch (status) {
      case BookingStatus.upcoming:  return AppColors.primary;
      case BookingStatus.completed: return AppColors.success;
      case BookingStatus.cancelled: return AppColors.error;
    }
  }
}
