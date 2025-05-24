import 'dart:io';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/my_product_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/product_details_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/repositories/marketplace_repository.dart';
import 'package:offgrid_nation_app/features/marketplace/data/datasources/marketplace_remote_datasource.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/product_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/category_entity.dart';

class MarketplaceRepositoryImpl implements MarketplaceRepository {
  final MarketplaceRemoteDataSource remoteDataSource;

  MarketplaceRepositoryImpl({required this.remoteDataSource});

  @override
  Future<ProductEntity> addProduct({
    required String title,
    required String price,
    required String condition,
    required String description,
    required String category,
    required String lat,
    required String lng,
    List<File>? pictures,
  }) async {
    final response = await remoteDataSource.addProduct(
      title: title,
      price: price,
      condition: condition,
      description: description,
      category: category,
      lat: lat,
      lng: lng,
      pictures: pictures,
    );
    return ProductEntity.fromJson(response);
  }

  @override
  Future<ProductDetailsEntity> getProductDetails(String productId) async {
    final response = await remoteDataSource.getProductDetails(productId);
    return ProductDetailsEntity.fromJson(response);
  }

  @override
  Future<List<ProductEntity>> listProducts({
    required double latitude,
    required double longitude,
    int limit = 20,
    String? cursor,
    String? sortBy,
    String? categoryId,
  }) async {
    final response = await remoteDataSource.listProducts(
      latitude: latitude,
      longitude: longitude,
      limit: limit,
      cursor: cursor,
      sortBy: sortBy,
      category: categoryId,
    );
    return response
        .map((json) => ProductEntity.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<CategoryEntity>> getCategories() async {
    return await remoteDataSource.getCategories();
  }

  @override
  Future<Map<String, dynamic>> getRatings(String productId) async {
    return await remoteDataSource.getRatings(productId);
  }

  @override
  Future<Map<String, dynamic>> addRating({
    required String productId,
    required int star,
  }) async {
    return await remoteDataSource.addRating(productId: productId, star: star);
  }

  @override
  Future<List<ProductEntity>> listMyProducts(MyProductFilter filter) async {
    final data = await remoteDataSource.listMyProducts(filter);
    return data.map<ProductEntity>((e) => ProductEntity.fromJson(e)).toList();
  }

  @override
  Future<void> deleteProduct(String productId) async {
    return await remoteDataSource.deleteProduct(productId);
  }

  @override
  Future<List<ProductEntity>> searchProducts({
    required String query,
    String? category,
    String? sort,
    double? lat,
    double? lng,
    int page = 1,
    int limit = 20,
  }) async {
    return await remoteDataSource.searchProducts(
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
