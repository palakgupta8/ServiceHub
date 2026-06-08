import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/models/service_category_model.dart';
import '../../../shared/models/service_model.dart';

// Provider<T>: holds static data — rebuilds widgets when value changes
final categoriesProvider = Provider<List<ServiceCategoryModel>>((ref) {
  return MockData.categories;
});

final popularServicesProvider = Provider<List<ServiceModel>>((ref) {
  return MockData.popularServices;
});

final promoBannersProvider = Provider<List<PromoBanner>>((ref) {
  return MockData.promoBanners;
});

// FutureProvider: runs an async function and exposes 3 states:
//   AsyncLoading  → data is being fetched  → show shimmer
//   AsyncData     → fetch succeeded        → show real content
//   AsyncError    → fetch failed           → show error
//
// Right now it simulates a 1.5s network delay with mock data.
// To connect a real API later: replace the body with a dio/http call.
// The HomeScreen code does NOT change — only this provider changes.
final homeDataProvider = FutureProvider<bool>((ref) async {
  // Simulate API response delay
  await Future.delayed(const Duration(milliseconds: 1500));
  return true; // true = data loaded successfully
});
