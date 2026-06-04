import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../shared/data/mock_data.dart';
import '../../../shared/models/service_category_model.dart';
import '../../../shared/models/service_model.dart';

// Provider<T>: the simplest Riverpod provider
// It holds a value that never changes on its own
// Any widget that reads it will get the same value every time
// Later: swap MockData.categories with a real API call — widgets don't change at all

final categoriesProvider = Provider<List<ServiceCategoryModel>>((ref) {
  return MockData.categories;
});

final popularServicesProvider = Provider<List<ServiceModel>>((ref) {
  return MockData.popularServices;
});

final promoBannersProvider = Provider<List<PromoBanner>>((ref) {
  return MockData.promoBanners;
});
