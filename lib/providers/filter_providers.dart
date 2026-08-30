import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/models/product.dart';
import '../domain/models/product_filter.dart';
import 'product_providers.dart';

class FilterNotifier extends StateNotifier<ProductFilter> {
  FilterNotifier() : super(const ProductFilter());

  void setSearchQuery(String query) {
    state = state.copyWith(searchQuery: query);
  }

  void setCategory(String? category) {
    state = state.copyWith(category: category, clearCategory: category == null);
  }

  void setSortOption(SortOption option) {
    state = state.copyWith(sortOption: option);
  }

  void resetFilters() {
    state = const ProductFilter();
  }
}

final filterProvider = StateNotifierProvider<FilterNotifier, ProductFilter>(
  (ref) => FilterNotifier(),
);

final filteredProductsProvider = FutureProvider<List<Product>>((ref) async {
  final products = await ref.watch(productsProvider.future);
  final filter = ref.watch(filterProvider);

  var filteredProducts = List<Product>.from(products);

  // Recherche
  final query = filter.searchQuery.trim().toLowerCase();

  if (query.isNotEmpty) {
    filteredProducts = filteredProducts.where((product) {
      return product.name.toLowerCase().contains(query) ||
          product.description.toLowerCase().contains(query) ||
          product.category.toLowerCase().contains(query);
    }).toList();
  }

  // Catégorie
  if (filter.category != null) {
    filteredProducts = filteredProducts
        .where((product) => product.category == filter.category)
        .toList();
  }

  // Tri
  switch (filter.sortOption) {
    case SortOption.priceLowToHigh:
      filteredProducts.sort((a, b) => a.price.compareTo(b.price));
      break;

    case SortOption.priceHighToLow:
      filteredProducts.sort((a, b) => b.price.compareTo(a.price));
      break;

    case SortOption.ratingHighToLow:
      filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
      break;

    case SortOption.nameAZ:
      filteredProducts.sort(
        (a, b) => a.name.toLowerCase().compareTo(b.name.toLowerCase()),
      );
      break;

    case SortOption.none:
      break;
  }

  return filteredProducts;
});
