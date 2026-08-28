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
  final double? minPrice;
  final double? maxPrice;
  final SortOption sortOption;

  const ProductFilter({
    this.searchQuery = '',
    this.category,
    this.minPrice,
    this.maxPrice,
    this.sortOption = SortOption.none,
  });

  ProductFilter copyWith({
    String? searchQuery,
    String? category,
    double? minPrice,
    double? maxPrice,
    SortOption? sortOption,
    bool clearCategory = false,
  }) {
    return ProductFilter(
      searchQuery: searchQuery ?? this.searchQuery,
      category: clearCategory ? null : category ?? this.category,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sortOption: sortOption ?? this.sortOption,
    );
  }
}
