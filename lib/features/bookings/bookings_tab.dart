import 'package:flutter/material.dart';
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
                      children: bookings
                          .map((b) => BookingHistoryCard(booking: b))
                          .toList(),
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
            onTap: () => setState(() => _selectedFilter = filter),
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
    return SizedBox(
      height: 400,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: AppColors.primaryLight,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.calendar_today_outlined,
                  size: 36, color: AppColors.primary),
            ),
            const SizedBox(height: 20),
            Text('No bookings found', style: AppTextStyles.headingSmall),
            const SizedBox(height: 8),
            Text(
              'Your bookings will appear here',
              style: AppTextStyles.bodyMedium
                  .copyWith(color: AppColors.textSecondary),
            ),
          ],
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
