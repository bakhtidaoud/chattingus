import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/marketplace_models.dart';
import '../../data/services/marketplace_service.dart';

final marketplaceServiceProvider = Provider((ref) => MarketplaceService());

final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final service = ref.watch(marketplaceServiceProvider);
  final response = await service.getCategories();
  return (response.data as List).map((c) => Category.fromJson(c)).toList();
});

final listingsProvider = FutureProvider.family<List<Listing>, String?>((
  ref,
  categoryId,
) async {
  final service = ref.watch(marketplaceServiceProvider);
  final response = await service.getListings(categoryId: categoryId);
  return (response.data['results'] as List)
      .map((l) => Listing.fromJson(l))
      .toList();
});

final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final searchQueryProvider = StateProvider<String>((ref) => "");
