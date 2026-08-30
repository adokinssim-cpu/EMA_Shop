enum SortOption {
  none,
  priceLowToHigh,
  priceHighToLow,
  ratingHighToLow,
  nameAZ,
}

class ProductFilter {
  final String searchQuery;
  final String? category;
  final SortOption sortOption;

  const ProductFilter({
    this.searchQuery = '',
    this.category,
    this.sortOption = SortOption.none,
  });

  ProductFilter copyWith({
    String? searchQuery,
    String? category,
    SortOption? sortOption,
    bool clearCategory = false,
  }) {
    return ProductFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      category: clearCategory ? null : category ?? this.category,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}
