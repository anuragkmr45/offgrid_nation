import 'dart:io';
import 'package:equatable/equatable.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/entities/my_product_entity.dart';

abstract class MarketplaceEvent extends Equatable {
  const MarketplaceEvent();

  @override
  List<Object?> get props => [];
}

class AddProductRequested extends MarketplaceEvent {
  final List<File> pictures;
  final String title;
  final String price;
  final String condition;
  final String description;
  final String category;
  final String lng;
  final String lat;

  const AddProductRequested({
    required this.pictures,
    required this.title,
    required this.price,
    required this.condition,
    required this.description,
    required this.category,
    required this.lng,
    required this.lat,
  });

  @override
  List<Object?> get props => [
    title,
    price,
    condition,
    description,
    category,
    lat,
    lng,
    pictures,
  ];
}

class FetchCategoriesRequested extends MarketplaceEvent {
  const FetchCategoriesRequested();
}

class FetchProductDetailsRequested extends MarketplaceEvent {
  final String productId;

  const FetchProductDetailsRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}

class FetchProductsRequested extends MarketplaceEvent {
  final double latitude;
  final double longitude;
  final int limit;
  final String? cursor;
  final String? sortBy;
  final String? categoryId;

  const FetchProductsRequested({
    required this.latitude,
    required this.longitude,
    this.limit = 20,
    this.cursor,
    this.sortBy,
    this.categoryId,
  });

  @override
  List<Object?> get props => [
    latitude,
    longitude,
    limit,
    cursor,
    sortBy,
    categoryId,
  ];
}

class AddRatingRequested extends MarketplaceEvent {
  final String productId;
  final int star;

  const AddRatingRequested({required this.productId, required this.star});

  @override
  List<Object?> get props => [productId, star];
}

class FetchRatingsRequested extends MarketplaceEvent {
  final String productId;

  const FetchRatingsRequested(this.productId);

  @override
  List<Object?> get props => [productId];
}

class FetchMyProductsRequested extends MarketplaceEvent {
  final MyProductFilter filter;

  const FetchMyProductsRequested({required this.filter});

  @override
  List<Object?> get props => [filter];
}
