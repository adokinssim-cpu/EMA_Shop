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
    if (category == null) {
      state = state.copyWith(clearCategory: true);
      return;
    }

    state = state.copyWith(category: category);
  }

  void setMinPrice(double? price) {
    state = ProductFilter(
      searchQuery: state.searchQuery,
      category: state.category,
      minPrice: price,
      maxPrice: state.maxPrice,
      sortOption: state.sortOption,
    );
  }

  void setMaxPrice(double? price) {
    state = ProductFilter(
      searchQuery: state.searchQuery,
      category: state.category,
      minPrice: state.minPrice,
      maxPrice: price,
      sortOption: state.sortOption,
    );
  }

  void setSortOption(SortOption option) {
    state = state.copyWith(sortOption: option);
  }

  void clearFilters() {
    state = const ProductFilter();
  }
}

final filterProvider = StateNotifierProvider<FilterNotifier, ProductFilter>((
  ref,
) {
  return FilterNotifier();
});

final filteredProductsProvider = Provider<AsyncValue<List<Product>>>((ref) {
  final productsAsync = ref.watch(productsProvider);
  final filter = ref.watch(filterProvider);

  return productsAsync.whenData((products) {
    var filtered = [...products];

    // Recherche
    if (filter.searchQuery.isNotEmpty) {
      final query = filter.searchQuery.toLowerCase();

      filtered = filtered.where((product) {
        return product.name.toLowerCase().contains(query) ||
            product.description.toLowerCase().contains(query) ||
            product.category.toLowerCase().contains(query);
      }).toList();
    }

    // Catégorie
    if (filter.category != null) {
      filtered = filtered
          .where((product) => product.category == filter.category)
          .toList();
    }

    // Prix minimum
    if (filter.minPrice != null) {
      filtered = filtered
          .where((product) => product.price >= filter.minPrice!)
          .toList();
    }

    // Prix maximum
    if (filter.maxPrice != null) {
      filtered = filtered
          .where((product) => product.price <= filter.maxPrice!)
          .toList();
    }

    // Tri
    switch (filter.sortOption) {
      case SortOption.priceLowToHigh:
        filtered.sort((a, b) => a.price.compareTo(b.price));
        break;

      case SortOption.priceHighToLow:
        filtered.sort((a, b) => b.price.compareTo(a.price));
        break;

      case SortOption.ratingHighToLow:
        filtered.sort((a, b) => b.rating.compareTo(a.rating));
        break;

      case SortOption.nameAZ:
        filtered.sort((a, b) => a.name.compareTo(b.name));
        break;

      case SortOption.none:
        break;
    }

    return filtered;
  });
});
