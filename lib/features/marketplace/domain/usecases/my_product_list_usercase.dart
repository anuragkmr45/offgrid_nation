import 'package:offgrid_nation_app/features/marketplace/domain/entities/product_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/my_product_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/repositories/marketplace_repository.dart';

class MyProductListUseCase {
  final MarketplaceRepository repository;

  MyProductListUseCase(this.repository);

  Future<List<ProductEntity>> call(MyProductFilter filter) {
    return repository.listMyProducts(filter);
  }
}
