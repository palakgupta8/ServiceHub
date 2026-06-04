import 'package:flutter/material.dart';
import '../models/service_category_model.dart';
import '../models/service_model.dart';
import '../models/review_model.dart';
import '../models/service_provider_model.dart';
import '../models/booking_model.dart';

// All mock data lives here — one place to edit when connecting real API later
// Every list is unmodifiable to prevent accidental mutation anywhere in the app
class MockData {
  MockData._();

  // ── Categories ──────────────────────────────────────────────────────────
  static final List<ServiceCategoryModel> categories = List.unmodifiable([
    const ServiceCategoryModel(
      id: 'cleaning',
      name: 'Cleaning',
      icon: Icons.cleaning_services_rounded,
      backgroundColor: Color(0xFFEEF1FF),
      iconColor: Color(0xFF4F6AF5),
    ),
    const ServiceCategoryModel(
      id: 'plumbing',
      name: 'Plumbing',
      icon: Icons.plumbing_rounded,
      backgroundColor: Color(0xFFFFF0F0),
      iconColor: Color(0xFFFF6B6B),
    ),
    const ServiceCategoryModel(
      id: 'electrical',
      name: 'Electrical',
      icon: Icons.electrical_services_rounded,
      backgroundColor: Color(0xFFFFFBE6),
      iconColor: Color(0xFFFFB822),
    ),
    const ServiceCategoryModel(
      id: 'beauty',
      name: 'Beauty',
      icon: Icons.spa_rounded,
      backgroundColor: Color(0xFFFFF0F8),
      iconColor: Color(0xFFE91E8C),
    ),
    const ServiceCategoryModel(
      id: 'painting',
      name: 'Painting',
      icon: Icons.format_paint_rounded,
      backgroundColor: Color(0xFFF3F0FF),
      iconColor: Color(0xFF7C4DFF),
    ),
    const ServiceCategoryModel(
      id: 'ac_repair',
      name: 'AC Repair',
      icon: Icons.ac_unit_rounded,
      backgroundColor: Color(0xFFE6F9FF),
      iconColor: Color(0xFF00BCD4),
    ),
    const ServiceCategoryModel(
      id: 'carpentry',
      name: 'Carpentry',
      icon: Icons.handyman_rounded,
      backgroundColor: Color(0xFFFFF3E0),
      iconColor: Color(0xFFFF9800),
    ),
    const ServiceCategoryModel(
      id: 'pest_control',
      name: 'Pest Control',
      icon: Icons.pest_control_rounded,
      backgroundColor: Color(0xFFF0FFF4),
      iconColor: Color(0xFF2DD36F),
    ),
  ]);

  // ── Popular Services ─────────────────────────────────────────────────────
  static final List<ServiceModel> popularServices = List.unmodifiable([
    ServiceModel(
      id: 's1',
      name: 'Home Deep Cleaning',
      categoryId: 'cleaning',
      categoryName: 'Cleaning',
      price: 999,
      rating: 4.8,
      reviewCount: 2300,
      durationMinutes: 180,
      description:
          'Complete deep cleaning of your home including kitchen, bathrooms, and all rooms.',
      cardColor: const Color(0xFFEEF1FF),
    ),
    ServiceModel(
      id: 's2',
      name: 'Plumbing Repair',
      categoryId: 'plumbing',
      categoryName: 'Plumbing',
      price: 399,
      rating: 4.6,
      reviewCount: 1100,
      durationMinutes: 60,
      description:
          'Fix leaking pipes, blocked drains, and all types of plumbing issues.',
      cardColor: const Color(0xFFFFF0F0),
    ),
    ServiceModel(
      id: 's3',
      name: 'Electrical Installation',
      categoryId: 'electrical',
      categoryName: 'Electrical',
      price: 599,
      rating: 4.7,
      reviewCount: 890,
      durationMinutes: 90,
      description:
          'Safe installation of switches, fans, lights, and electrical fittings.',
      cardColor: const Color(0xFFFFFBE6),
    ),
    ServiceModel(
      id: 's4',
      name: 'Haircut at Home',
      categoryId: 'beauty',
      categoryName: 'Beauty',
      price: 299,
      rating: 4.9,
      reviewCount: 3200,
      durationMinutes: 45,
      description:
          'Professional haircut and styling by expert beauticians at your doorstep.',
      cardColor: const Color(0xFFFFF0F8),
    ),
    ServiceModel(
      id: 's5',
      name: 'Interior Painting',
      categoryId: 'painting',
      categoryName: 'Painting',
      price: 1499,
      rating: 4.5,
      reviewCount: 560,
      durationMinutes: 480,
      description:
          'High-quality interior wall painting with premium paints and clean finish.',
      cardColor: const Color(0xFFF3F0FF),
    ),
    ServiceModel(
      id: 's6',
      name: 'AC Service & Repair',
      categoryId: 'ac_repair',
      categoryName: 'AC Repair',
      price: 449,
      rating: 4.7,
      reviewCount: 1800,
      durationMinutes: 60,
      description:
          'Complete AC servicing, gas refill, and repair by certified technicians.',
      cardColor: const Color(0xFFE6F9FF),
    ),
  ]);

  // ── Service Providers ────────────────────────────────────────────────────
  // serviceId → provider  (one provider per service for simplicity)
  static final Map<String, ServiceProviderModel> serviceProviders = {
    's1': const ServiceProviderModel(
      id: 'p1', name: 'Ravi Kumar', rating: 4.9,
      completedJobs: 1250, yearsExperience: 6, specialization: 'Deep Cleaning Expert',
    ),
    's2': const ServiceProviderModel(
      id: 'p2', name: 'Suresh Patel', rating: 4.7,
      completedJobs: 870, yearsExperience: 4, specialization: 'Plumbing Specialist',
    ),
    's3': const ServiceProviderModel(
      id: 'p3', name: 'Arjun Mehta', rating: 4.8,
      completedJobs: 640, yearsExperience: 5, specialization: 'Electrical Engineer',
    ),
    's4': const ServiceProviderModel(
      id: 'p4', name: 'Priya Sharma', rating: 5.0,
      completedJobs: 2100, yearsExperience: 7, specialization: 'Senior Beautician',
    ),
    's5': const ServiceProviderModel(
      id: 'p5', name: 'Mohit Singh', rating: 4.6,
      completedJobs: 390, yearsExperience: 3, specialization: 'Interior Painting',
    ),
    's6': const ServiceProviderModel(
      id: 'p6', name: 'Dinesh Rao', rating: 4.8,
      completedJobs: 1100, yearsExperience: 5, specialization: 'AC & HVAC Technician',
    ),
  };

  // ── What's Included ───────────────────────────────────────────────────────
  // serviceId → list of included items
  static final Map<String, List<String>> serviceIncludes = {
    's1': ['Kitchen deep cleaning', 'Bathroom scrubbing', 'Floor mopping & wiping', 'Dusting all surfaces', 'Trash removal'],
    's2': ['Pipe leak fixing', 'Drain unblocking', 'Tap & faucet repair', 'Water pressure check', 'Free follow-up visit'],
    's3': ['Switch & socket installation', 'Fan & light fitting', 'Wiring inspection', 'MCB/fuse replacement', 'Safety certificate'],
    's4': ['Haircut & styling', 'Hair wash', 'Blow dry', 'Head massage', 'Product application'],
    's5': ['Wall surface preparation', 'Primer coat', '2 coats of paint', 'Edge finishing', 'Clean-up after work'],
    's6': ['Full AC service & cleaning', 'Gas pressure check', 'Cooling performance test', 'Filter cleaning', '30-day service warranty'],
  };

  // ── Reviews ───────────────────────────────────────────────────────────────
  static final List<ReviewModel> reviews = List.unmodifiable([
    // s1 — Home Deep Cleaning
    const ReviewModel(id: 'r1', serviceId: 's1', userName: 'Anjali R.', userInitials: 'AR', rating: 5.0, date: '2 days ago', comment: 'Absolutely spotless! The team was professional and thorough. My kitchen looks brand new.'),
    const ReviewModel(id: 'r2', serviceId: 's1', userName: 'Kiran M.', userInitials: 'KM', rating: 4.5, date: '1 week ago', comment: 'Great service overall. Arrived on time and finished in 3 hours. Would book again.'),
    // s2 — Plumbing
    const ReviewModel(id: 'r3', serviceId: 's2', userName: 'Rahul V.', userInitials: 'RV', rating: 5.0, date: '3 days ago', comment: 'Fixed a leak I had been struggling with for weeks. Fast and affordable.'),
    const ReviewModel(id: 'r4', serviceId: 's2', userName: 'Deepa S.', userInitials: 'DS', rating: 4.0, date: '2 weeks ago', comment: 'Good work, though arrived 20 mins late. The repair itself was excellent.'),
    // s3 — Electrical
    const ReviewModel(id: 'r5', serviceId: 's3', userName: 'Naveen K.', userInitials: 'NK', rating: 5.0, date: '5 days ago', comment: 'Very knowledgeable electrician. Installed 6 lights and 3 fans cleanly.'),
    const ReviewModel(id: 'r6', serviceId: 's3', userName: 'Meena T.', userInitials: 'MT', rating: 4.5, date: '3 weeks ago', comment: 'Professional and clean work. Explained everything he was doing. Highly recommend.'),
    // s4 — Haircut
    const ReviewModel(id: 'r7', serviceId: 's4', userName: 'Sneha P.', userInitials: 'SP', rating: 5.0, date: '1 day ago', comment: 'Priya is amazing! Best haircut I have had in years, and I did not even leave home.'),
    const ReviewModel(id: 'r8', serviceId: 's4', userName: 'Lakshmi A.', userInitials: 'LA', rating: 5.0, date: '4 days ago', comment: 'So convenient. Brought all her own tools, very hygienic. Will book every month!'),
    // s5 — Painting
    const ReviewModel(id: 'r9', serviceId: 's5', userName: 'Vinod J.', userInitials: 'VJ', rating: 4.5, date: '1 week ago', comment: 'Two rooms painted in a day. Clean edges and no drips on the floor.'),
    const ReviewModel(id: 'r10', serviceId: 's5', userName: 'Rekha G.', userInitials: 'RG', rating: 4.0, date: '2 weeks ago', comment: 'Decent job. Took longer than expected but the finish quality is good.'),
    // s6 — AC Repair
    const ReviewModel(id: 'r11', serviceId: 's6', userName: 'Sunil B.', userInitials: 'SB', rating: 5.0, date: '2 days ago', comment: 'AC was barely cooling. After service, it feels like brand new. Very satisfied.'),
    const ReviewModel(id: 'r12', serviceId: 's6', userName: 'Pooja N.', userInitials: 'PN', rating: 4.5, date: '1 week ago', comment: 'Thorough service. Dinesh explained the gas leak issue and fixed it properly.'),
  ]);

  // Helper: get reviews for a specific service
  static List<ReviewModel> reviewsForService(String serviceId) =>
      reviews.where((r) => r.serviceId == serviceId).toList();

  // Helper: get a service by ID
  static ServiceModel? serviceById(String id) {
    try {
      return popularServices.firstWhere((s) => s.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Promo Banners ────────────────────────────────────────────────────────
  // Each banner: title, subtitle, color, icon
  static final List<PromoBanner> promoBanners = List.unmodifiable([
    const PromoBanner(
      title: '30% Off First Booking',
      subtitle: 'Use code FIRST30 at checkout',
      backgroundColor: Color(0xFF4F6AF5),
      icon: Icons.local_offer_rounded,
    ),
    const PromoBanner(
      title: 'AC Service at ₹399',
      subtitle: 'Summer special — book before June 30',
      backgroundColor: Color(0xFF00BCD4),
      icon: Icons.ac_unit_rounded,
    ),
    const PromoBanner(
      title: 'Beauty at Home',
      subtitle: 'Professional salon services, now at home',
      backgroundColor: Color(0xFFE91E8C),
      icon: Icons.spa_rounded,
    ),
  ]);

  // ── Mock Bookings (current user's booking history) ────────────────────
  static final List<BookingModel> myBookings = List.unmodifiable([
    const BookingModel(
      id: 'b1',
      serviceId: 's6',
      serviceName: 'AC Service & Repair',
      categoryName: 'AC Repair',
      date: '8 Jun 2026',
      timeSlot: '11:00 AM',
      address: 'HSR Layout, Bangalore - 560102',
      price: 449,
      status: BookingStatus.upcoming,
    ),
    const BookingModel(
      id: 'b2',
      serviceId: 's1',
      serviceName: 'Home Deep Cleaning',
      categoryName: 'Cleaning',
      date: '2 Jun 2026',
      timeSlot: '9:00 AM',
      address: 'HSR Layout, Bangalore - 560102',
      price: 999,
      status: BookingStatus.completed,
    ),
    const BookingModel(
      id: 'b3',
      serviceId: 's4',
      serviceName: 'Haircut at Home',
      categoryName: 'Beauty',
      date: '28 May 2026',
      timeSlot: '3:00 PM',
      address: 'HSR Layout, Bangalore - 560102',
      price: 299,
      status: BookingStatus.completed,
    ),
    const BookingModel(
      id: 'b4',
      serviceId: 's2',
      serviceName: 'Plumbing Repair',
      categoryName: 'Plumbing',
      date: '20 May 2026',
      timeSlot: '12:00 PM',
      address: 'HSR Layout, Bangalore - 560102',
      price: 399,
      status: BookingStatus.cancelled,
    ),
  ]);
}

// Small data class just for banners — no need for a separate file
class PromoBanner {
  final String title;
  final String subtitle;
  final Color backgroundColor;
  final IconData icon;

  const PromoBanner({
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.icon,
  });
}
