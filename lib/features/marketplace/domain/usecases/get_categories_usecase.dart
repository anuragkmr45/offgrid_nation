import 'package:offgrid_nation_app/features/marketplace/domain/entities/category_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/repositories/marketplace_repository.dart';

class GetCategoriesUseCase {
  final MarketplaceRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<CategoryEntity>> call() {
    return repository.getCategories();
  }
}
