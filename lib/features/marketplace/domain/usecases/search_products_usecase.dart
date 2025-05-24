import 'package:offgrid_nation_app/features/marketplace/domain/entities/product_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/repositories/marketplace_repository.dart';

class SearchProductsUseCase {
  final MarketplaceRepository repository;

  SearchProductsUseCase(this.repository);

  Future<List<ProductEntity>> call({
    required String query,
    String? category,
    String? sort,
    double? lat,
    double? lng,
    int page = 1,
    int limit = 20,
  }) {
    return repository.searchProducts(
      query: query,
      category: category,
      sort: sort,
      lat: lat,
      lng: lng,
      page: page,
      limit: limit,
    );
  }
}