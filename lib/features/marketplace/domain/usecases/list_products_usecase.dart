import 'package:offgrid_nation_app/features/marketplace/domain/entities/product_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/repositories/marketplace_repository.dart';

class ListProductsUseCase {
  final MarketplaceRepository repository;

  ListProductsUseCase(this.repository);

  Future<List<ProductEntity>> call({
    required double latitude,
    required double longitude,
    int limit = 20,
    String? cursor,
    String? sortBy,
    String? categoryId,
  }) {
    return repository.listProducts(
      latitude: latitude,
      longitude: longitude,
      limit: limit,
      cursor: cursor,
      sortBy: sortBy,
      categoryId: categoryId,
    );
  }
}
