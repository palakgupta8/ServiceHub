import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../shared/data/mock_data.dart';
import '../../shared/models/service_model.dart';
import '../../shared/utils/category_utils.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/constants/app_constants.dart';
import '../../core/router/app_router.dart';
import 'widgets/review_card.dart';

class ServiceDetailScreen extends StatefulWidget {
  // serviceId comes from the route parameter: /service/:id
  final String serviceId;

  const ServiceDetailScreen({super.key, required this.serviceId});

  @override
  State<ServiceDetailScreen> createState() => _ServiceDetailScreenState();
}

class _ServiceDetailScreenState extends State<ServiceDetailScreen> {
  bool _isFavourite = false;

  @override
  Widget build(BuildContext context) {
    // Look up the service by ID from mock data
    final ServiceModel? service = MockData.serviceById(widget.serviceId);

    // If ID not found (shouldn't happen with mock data, but safe practice)
    if (service == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const Center(child: Text('Service not found')),
      );
    }

    final provider = MockData.serviceProviders[service.id];
    final includes = MockData.serviceIncludes[service.id] ?? [];
    final reviews = MockData.reviewsForService(service.id);

    return Scaffold(
      backgroundColor: AppColors.background,

      // ── Sticky Book Now button ─────────────────────────────────────────
      // Using bottomNavigationBar slot for a sticky action button
      // This keeps the button always visible regardless of scroll position
      bottomNavigationBar: _buildBookButton(service),

      body: CustomScrollView(
        slivers: [
          // ── Collapsible image header ─────────────────────────────────
          SliverAppBar(
            expandedHeight: 260,
            // pinned: true → collapsed AppBar stays at top when scrolled
            // (shows back button even when header is scrolled away)
            pinned: true,
            // stretch: true → header stretches slightly on over-scroll
            stretch: true,
            backgroundColor: service.cardColor,
            foregroundColor: AppColors.textPrimary,
            leading: _buildBackButton(),
            actions: [_buildFavouriteButton()],

            flexibleSpace: FlexibleSpaceBar(
              // FlexibleSpaceBar: the content inside the collapsible header
              // background: shown when expanded, fades as you scroll up
              background: Container(
                color: service.cardColor,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 60), // space for status bar
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.1),
                            blurRadius: 20,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Icon(
                        _iconForCategory(service.categoryId),
                        size: 56,
                        color: _colorForCategory(service.categoryId),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // ── Content ──────────────────────────────────────────────────
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Service header (name, rating, price)
                _buildServiceHeader(service),
                _buildDivider(),

                // About
                _buildSection(
                  title: 'About This Service',
                  child: Text(
                    service.description,
                    style: AppTextStyles.bodyLarge.copyWith(
                      color: AppColors.textSecondary,
                      height: 1.6,
                    ),
                  ),
                ),
                _buildDivider(),

                // What's Included
                if (includes.isNotEmpty) ...[
                  _buildSection(
                    title: "What's Included",
                    child: Column(
                      children: includes
                          .map((item) => _buildIncludeItem(item))
                          .toList(),
                    ),
                  ),
                  _buildDivider(),
                ],

                // Provider
                if (provider != null) ...[
                  _buildSection(
                    title: 'Service Provider',
                    child: _buildProviderCard(provider),
                  ),
                  _buildDivider(),
                ],

                // Reviews
                if (reviews.isNotEmpty)
                  _buildSection(
                    title: 'Customer Reviews (${reviews.length})',
                    child: Column(
                      children: reviews.map((r) => ReviewCard(review: r)).toList(),
                    ),
                  ),

                const SizedBox(height: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Section wrapper — keeps all sections consistent ────────────────────
  Widget _buildSection({required String title, required Widget child}) {
    return Padding(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.headingMedium),
          const SizedBox(height: 14),
          child,
        ],
      ),
    );
  }

  Widget _buildDivider() => const Divider(height: 1, thickness: 1);

  // ── Service header ─────────────────────────────────────────────────────
  Widget _buildServiceHeader(ServiceModel service) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(AppConstants.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category chip
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: service.cardColor,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(service.categoryName,
                style: AppTextStyles.bodySmall.copyWith(
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(height: 10),

          Text(service.name, style: AppTextStyles.headingLarge),
          const SizedBox(height: 12),

          // Rating + duration row
          Row(
            children: [
              const Icon(Icons.star_rounded, size: 16, color: AppColors.star),
              const SizedBox(width: 4),
              Text(
                service.rating.toStringAsFixed(1),
                style: AppTextStyles.bodyMedium.copyWith(
                    fontWeight: FontWeight.w600),
              ),
              Text(
                '  (${service.formattedReviews} reviews)',
                style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary),
              ),
              const SizedBox(width: 16),
              const Icon(Icons.access_time_rounded,
                  size: 14, color: AppColors.textSecondary),
              const SizedBox(width: 4),
              Text(
                '${service.durationMinutes} min',
                style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Price
          Text(service.formattedPrice, style: AppTextStyles.price.copyWith(fontSize: 22)),
        ],
      ),
    );
  }

  // ── Include item ────────────────────────────────────────────────────────
  Widget _buildIncludeItem(String item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: const BoxDecoration(
              color: AppColors.primaryLight,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check_rounded,
                size: 14, color: AppColors.primary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(item, style: AppTextStyles.bodyMedium),
          ),
        ],
      ),
    );
  }

  // ── Provider card ───────────────────────────────────────────────────────
  Widget _buildProviderCard(provider) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          // Avatar with initials
          CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primaryLight,
            child: Text(
              provider.name.split(' ').map((n) => n[0]).join(),
              style: AppTextStyles.headingSmall.copyWith(
                  color: AppColors.primary),
            ),
          ),
          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(provider.name, style: AppTextStyles.headingSmall),
                const SizedBox(height: 4),
                Text(provider.specialization,
                    style: AppTextStyles.bodySmall),
                const SizedBox(height: 8),
                Row(
                  children: [
                    _providerStat(
                        Icons.star_rounded, '${provider.rating}', AppColors.star),
                    const SizedBox(width: 16),
                    _providerStat(Icons.check_circle_outline_rounded,
                        '${provider.formattedJobs} jobs', AppColors.success),
                    const SizedBox(width: 16),
                    _providerStat(Icons.work_outline_rounded,
                        '${provider.yearsExperience} yrs', AppColors.primary),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _providerStat(IconData icon, String label, Color color) {
    return Row(
      children: [
        Icon(icon, size: 13, color: color),
        const SizedBox(width: 3),
        Text(label,
            style: AppTextStyles.bodySmall.copyWith(
                fontWeight: FontWeight.w600, color: AppColors.textPrimary)),
      ],
    );
  }

  // ── Sticky book button ──────────────────────────────────────────────────
  Widget _buildBookButton(ServiceModel service) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: ElevatedButton(
        onPressed: () => context.push(AppRoutes.booking, extra: service.id),
        child: Text('Book Now — ${service.formattedPrice}'),
      ),
    );
  }

  // ── Back button with white background ──────────────────────────────────
  Widget _buildBackButton() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () => context.pop(),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8),
            ],
          ),
          child: const Icon(Icons.arrow_back_ios_new,
              size: 16, color: AppColors.textPrimary),
        ),
      ),
    );
  }

  // ── Favourite toggle button ─────────────────────────────────────────────
  Widget _buildFavouriteButton() {
    return Padding(
      padding: const EdgeInsets.all(8),
      child: GestureDetector(
        onTap: () => setState(() => _isFavourite = !_isFavourite),
        child: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 8),
            ],
          ),
          child: Icon(
            _isFavourite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
            size: 18,
            color: _isFavourite ? AppColors.error : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  IconData _iconForCategory(String id) => CategoryUtils.iconFor(id);
  Color _colorForCategory(String id) => CategoryUtils.colorFor(id);
}
