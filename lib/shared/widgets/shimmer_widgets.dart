import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import '../../core/constants/app_constants.dart';

// Base shimmer wrapper — applies the pulsing animation to any child
// baseColor:      the "rest" color (darker grey)
// highlightColor: the "shine" color (lighter grey) that sweeps across
class AppShimmer extends StatelessWidget {
  final Widget child;

  const AppShimmer({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      child: child,
    );
  }
}

// A plain grey box — the building block for all skeletons
// Replace real content with these to match the layout shape
class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    required this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

// ── Skeleton for the promo banner carousel ──────────────────────────────────
class BannerShimmer extends StatelessWidget {
  const BannerShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Column(
        children: [
          // Banner rectangle
          ShimmerBox(
            width: double.infinity,
            height: 160,
            borderRadius: 20,
          ),
          const SizedBox(height: 12),
          // Dots row
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              3,
              (i) => Container(
                width: i == 0 ? 20 : 6,
                height: 6,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Skeleton for the horizontal categories row ──────────────────────────────
class CategoryShimmer extends StatelessWidget {
  const CategoryShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: SizedBox(
        height: 96,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          itemCount: 6,
          itemBuilder: (_, __) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: Column(
              children: [
                // Circle for icon
                const ShimmerBox(
                    width: 60, height: 60, borderRadius: 30),
                const SizedBox(height: 8),
                // Label
                ShimmerBox(
                    width: 48, height: 10, borderRadius: 5),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ── Skeleton for a single service card ──────────────────────────────────────
class ServiceCardShimmer extends StatelessWidget {
  const ServiceCardShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return AppShimmer(
      child: Container(
        height: 110,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusL),
        ),
        child: Row(
          children: [
            // Image placeholder
            ShimmerBox(
              width: 110,
              height: 110,
              borderRadius: AppConstants.radiusL.toDouble(),
            ),
            const SizedBox(width: 14),

            // Text lines
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ShimmerBox(width: 80, height: 10),
                    ShimmerBox(width: double.infinity, height: 14),
                    ShimmerBox(width: 140, height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ShimmerBox(width: 60, height: 16),
                        ShimmerBox(width: 50, height: 28, borderRadius: 8),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 14),
          ],
        ),
      ),
    );
  }
}

// ── Full home screen skeleton ────────────────────────────────────────────────
// Combines all shimmer pieces to match the home screen layout exactly
class HomeScreenShimmer extends StatelessWidget {
  const HomeScreenShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      // NeverScrollableScrollPhysics: skeleton shouldn't be scrollable
      // It's just a visual placeholder, not interactive
      padding: const EdgeInsets.all(AppConstants.paddingM),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 20),

          // Banner
          const BannerShimmer(),

          const SizedBox(height: 28),

          // "Categories" label + row
          AppShimmer(child: ShimmerBox(width: 120, height: 18)),
          const SizedBox(height: 16),
          const CategoryShimmer(),

          const SizedBox(height: 28),

          // "Popular Services" label
          AppShimmer(child: ShimmerBox(width: 160, height: 18)),
          const SizedBox(height: 16),

          // Service cards
          const ServiceCardShimmer(),
          const ServiceCardShimmer(),
          const ServiceCardShimmer(),
        ],
      ),
    );
  }
}
