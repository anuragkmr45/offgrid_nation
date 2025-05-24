import 'package:offgrid_nation_app/features/marketplace/domain/entities/product_details_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/repositories/marketplace_repository.dart';

class GetProductDetailsUseCase {
  final MarketplaceRepository repository;

  GetProductDetailsUseCase(this.repository);

  Future<ProductDetailsEntity> call(String productId) {
    return repository.getProductDetails(productId);
  }
}
