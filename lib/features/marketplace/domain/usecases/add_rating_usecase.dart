import 'package:offgrid_nation_app/features/marketplace/domain/repositories/marketplace_repository.dart';

class AddRatingUseCase {
  final MarketplaceRepository repository;

  AddRatingUseCase(this.repository);

  Future<Map<String, dynamic>> call({
    required String productId,
    required int star,
  }) {
    return repository.addRating(productId: productId, star: star);
  }
}
