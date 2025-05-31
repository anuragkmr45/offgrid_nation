enum ProductSortOption {
  popularity,
  rating,
  recent,
  priceAsc,
  priceDesc;

  String get label {
    switch (this) {
      case ProductSortOption.popularity:
        return "Popularity";
      case ProductSortOption.rating:
        return "Rating";
      case ProductSortOption.recent:
        return "Newest First";
      case ProductSortOption.priceAsc:
        return "Price: Low to High";
      case ProductSortOption.priceDesc:
        return "Price: High to Low";
    }
  }

  String get apiValue {
    switch (this) {
      case ProductSortOption.popularity:
        return "popularity";
      case ProductSortOption.rating:
        return "rating";
      case ProductSortOption.recent:
        return "recent";
      case ProductSortOption.priceAsc:
        return "priceAsc";
      case ProductSortOption.priceDesc:
        return "priceDesc";
    }
  }
}
