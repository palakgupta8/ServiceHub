import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../profile/profile_screen.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../shared/models/service_category_model.dart';
import 'providers/home_providers.dart';
import 'widgets/promo_banner.dart';
import 'widgets/category_section.dart';
import 'widgets/service_card.dart';
import 'widgets/section_header.dart';

// ConsumerStatefulWidget = StatefulWidget + Riverpod support
// Use this when you need both lifecycle methods (initState/dispose) AND providers
// For screens that only need providers (no lifecycle), use ConsumerWidget
class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedNavIndex = 0; // which bottom nav tab is active

  void _onCategoryTapped(ServiceCategoryModel category) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${category.name} selected'),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
      ),
    );
    // TODO: navigate to category services screen
  }

  @override
  Widget build(BuildContext context) {
    // ref.watch: reads the provider AND rebuilds this widget when value changes
    // For mock data it never changes, but pattern is correct for real APIs
    final categories = ref.watch(categoriesProvider);
    final services = ref.watch(popularServicesProvider);

    return Scaffold(
      backgroundColor: AppColors.background,

      // ── Bottom Navigation Bar ─────────────────────────────────────────
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedNavIndex,
        onTap: (index) => setState(() => _selectedNavIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today_outlined),
            activeIcon: Icon(Icons.calendar_today_rounded),
            label: 'Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline_rounded),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),

      // ── Body ──────────────────────────────────────────────────────────
      // IndexedStack: keeps all tabs alive in memory
      // Only the tab at [_selectedNavIndex] is visible
      // Benefit: scroll position is preserved when switching tabs
      body: IndexedStack(
        index: _selectedNavIndex,
        children: [
          _HomeTab(
            categories: categories,
            services: services,
            onCategoryTapped: _onCategoryTapped,
          ),
          const _BookingsTab(),
          const _ProfileTab(),
        ],
      ),
    );
  }
}

// ── Home Tab ────────────────────────────────────────────────────────────────
class _HomeTab extends StatelessWidget {
  final List categories;
  final List services;
  final void Function(ServiceCategoryModel) onCategoryTapped;

  const _HomeTab({
    required this.categories,
    required this.services,
    required this.onCategoryTapped,
  });

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      // CustomScrollView + Slivers: the Flutter way to build complex scrollable UIs
      // Better than SingleChildScrollView + Column because:
      //   - SliverAppBar can collapse/expand as you scroll
      //   - Slivers are lazy — only render what's visible = better performance
      slivers: [
        // ── Sticky AppBar ───────────────────────────────────────────────
        SliverAppBar(
          floating: true,     // shows appbar when scrolling up (even mid-scroll)
          snap: true,         // snaps fully open/closed — no half-states
          elevation: 0,
          backgroundColor: AppColors.background,
          automaticallyImplyLeading: false,
          title: _buildAppBarTitle(),
          actions: [_buildNotificationButton()],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(64),
            child: _buildSearchBar(),
          ),
        ),

        // ── Scrollable content ──────────────────────────────────────────
        // SliverToBoxAdapter: wraps a regular widget to use inside CustomScrollView
        // Everything that isn't natively a Sliver needs this wrapper
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // Promo Banners
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingM),
                child: const PromoBannerCarousel(),
              ),

              const SizedBox(height: 28),

              // Categories
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingM),
                child: SectionHeader(title: 'Categories', onSeeAll: () {}),
              ),
              const SizedBox(height: 16),
              CategorySection(
                categories: categories.cast<ServiceCategoryModel>(),
                onCategoryTapped: onCategoryTapped,
              ),

              const SizedBox(height: 28),

              // Popular Services
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingM),
                child: SectionHeader(
                    title: 'Popular Services', onSeeAll: () {}),
              ),
              const SizedBox(height: 16),

              // Services list — NOT inside a ListView (we're already in a scroll view)
              // Using Column + map is correct here because the parent handles scrolling
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: AppConstants.paddingM),
                child: Column(
                  children: services
                      .cast()
                      .map<Widget>(
                        (service) => ServiceCard(
                          service: service,
                          onTap: () => context.push('/service/${service.id}'),
                        ),
                      )
                      .toList(),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildAppBarTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            const Icon(Icons.location_on_rounded,
                size: 14, color: AppColors.primary),
            const SizedBox(width: 4),
            Text(
              'Bangalore, India',
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Icon(Icons.keyboard_arrow_down_rounded,
                size: 16, color: AppColors.primary),
          ],
        ),
        Text('Hi, John! 👋', style: AppTextStyles.headingSmall),
      ],
    );
  }

  Widget _buildNotificationButton() {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Stack(
        // Stack: lets you overlay widgets on top of each other
        // Used here to show a red dot badge on the bell icon
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.notifications_outlined,
                size: 20, color: AppColors.textPrimary),
          ),
          // Red dot badge (top-right of bell)
          Positioned(
            top: 6,
            right: 6,
            child: Container(
              width: 8,
              height: 8,
              decoration: const BoxDecoration(
                color: AppColors.error,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: TextField(
        readOnly: true, // tapping navigates to a search screen (not editable inline)
        onTap: () {
          // TODO: navigate to search screen
        },
        decoration: InputDecoration(
          hintText: 'Search for services...',
          prefixIcon: const Icon(Icons.search_rounded,
              color: AppColors.textSecondary, size: 20),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            borderSide: const BorderSide(color: AppColors.border),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(AppConstants.radiusM),
            borderSide: const BorderSide(color: AppColors.primary),
          ),
        ),
      ),
    );
  }
}

// ── Placeholder tabs ─────────────────────────────────────────────────────────
class _BookingsTab extends StatelessWidget {
  const _BookingsTab();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('My Bookings — coming soon'));
  }
}

class _ProfileTab extends StatelessWidget {
  const _ProfileTab();

  @override
  Widget build(BuildContext context) {
    return const ProfileScreen();
  }
}
