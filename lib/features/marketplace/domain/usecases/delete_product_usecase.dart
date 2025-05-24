import 'package:offgrid_nation_app/features/marketplace/domain/repositories/marketplace_repository.dart';

class DeleteProductUseCase {
  final MarketplaceRepository repository;

  DeleteProductUseCase(this.repository);

  Future<void> call(String productId) {
    return repository.deleteProduct(productId);
  }
}
