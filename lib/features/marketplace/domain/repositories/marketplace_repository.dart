import 'dart:io';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/category_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/my_product_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/product_details_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/product_entity.dart';

abstract class MarketplaceRepository {
  Future<ProductEntity> addProduct({
    required List<File> pictures,
    required String title,
    required String price,
    required String condition,
    required String description,
    required String category,
    required String lat,
    required String lng,
  });

  Future<ProductDetailsEntity> getProductDetails(String productId);

  Future<List<ProductEntity>> listProducts({
    required double latitude,
    required double longitude,
    int limit,
    String? cursor,
    String? sortBy,
    String? categoryId,
  });

  Future<Map<String, dynamic>> addRating({
    required String productId,
    required int star,
  });

  Future<Map<String, dynamic>> getRatings(String productId);

  Future<List<CategoryEntity>> getCategories();

  Future<List<ProductEntity>> listMyProducts(MyProductFilter filter);
}
