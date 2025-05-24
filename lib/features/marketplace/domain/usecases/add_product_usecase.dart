import 'dart:io';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/product_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/repositories/marketplace_repository.dart';

class AddProductUseCase {
  final MarketplaceRepository repository;

  AddProductUseCase(this.repository);

  Future<ProductEntity> call({
    required List<File> pictures,
    required String title,
    required String price,
    required String condition,
    required String description,
    required String category,
    required String lat,
    required String lng,
  }) {
    return repository.addProduct(
      pictures: pictures,
      title: title,
      price: price,
      condition: condition,
      description: description,
      category: category,
      lat: lat,
      lng: lng,
    );
  }
}
