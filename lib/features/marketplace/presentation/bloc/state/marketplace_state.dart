import 'package:equatable/equatable.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/category_entity.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/product_entity.dart';

abstract class MarketplaceState extends Equatable {
  @override
  List<Object?> get props => [];
}

class MarketplaceInitial extends MarketplaceState {}

class MarketplaceLoading extends MarketplaceState {}

class AddProductSuccess extends MarketplaceState {
  final ProductEntity product;

  AddProductSuccess(this.product);

  @override
  List<Object?> get props => [product];
}

class MarketplaceFailure extends MarketplaceState {
  final String error;

  MarketplaceFailure(this.error);

  @override
  List<Object?> get props => [error];
}

class CategoriesLoaded extends MarketplaceState {
  final List<CategoryEntity> categories;

  CategoriesLoaded(this.categories);

  @override
  List<Object?> get props => [categories];
}

class ProductDetailsLoaded extends MarketplaceState {
  final ProductEntity product;

  ProductDetailsLoaded(this.product);

  @override
  List<Object?> get props => [product];
}

class ProductsLoaded extends MarketplaceState {
  final List<ProductEntity> products;
  final String? nextCursor;

  ProductsLoaded({required this.products, this.nextCursor});

  @override
  List<Object?> get props => [products, nextCursor];
}

class RatingsLoaded extends MarketplaceState {
  final Map<String, dynamic> ratings;

  RatingsLoaded(this.ratings);

  @override
  List<Object?> get props => [ratings];
}

class MarketplaceError extends MarketplaceState {
  final String message;
  MarketplaceError(this.message);
}

class MarketplaceLoaded extends MarketplaceState {
  final List<ProductEntity> products;

  MarketplaceLoaded({required this.products});
}

class MyProductsLoaded extends MarketplaceState {
  final List<ProductEntity> myProducts;

  MyProductsLoaded({required this.myProducts});

  @override
  List<Object?> get props => [myProducts];
}
