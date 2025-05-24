import 'package:offgrid_nation_app/features/marketplace/domain/repositories/marketplace_repository.dart';

class GetRatingsUseCase {
  final MarketplaceRepository repository;

  GetRatingsUseCase(this.repository);

  Future<Map<String, dynamic>> call(String productId) {
    return repository.getRatings(productId);
  }
}
