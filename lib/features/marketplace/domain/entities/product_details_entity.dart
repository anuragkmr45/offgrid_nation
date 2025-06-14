import 'category_entity.dart';
import 'owner_entity.dart';
import 'location_entity.dart';

class ProductDetailsEntity {
  final String id;
  final String title;
  final List<String> images;
  final String price;
  final String condition;
  final String description;
  final CategoryEntity category;
  final LocationEntity location;
  final bool isSold;
  final String? soldTo;
  final int clickCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  final OwnerEntity owner;

  ProductDetailsEntity({
    required this.id,
    required this.title,
    required this.images,
    required this.price,
    required this.condition,
    required this.description,
    required this.category,
    required this.location,
    required this.isSold,
    required this.soldTo,
    required this.clickCount,
    required this.createdAt,
    required this.updatedAt,
    required this.owner,
  });

  factory ProductDetailsEntity.fromJson(Map<String, dynamic> json) {
    final dynamic ownerJson = json['owner'];
    final OwnerEntity owner =
        ownerJson is Map<String, dynamic>
            ? OwnerEntity.fromJson(ownerJson)
            : OwnerEntity(
              userId: ownerJson.toString(),
              username: 'Unknownt',
              profilePicture: '',
            );

    return ProductDetailsEntity(
      id: json['_id'],
      title: json['title'],
      images: List<String>.from(json['images']),
      price: json['price'],
      condition: json['condition'],
      description: json['description'],
      category: CategoryEntity.fromJson(json['category']),
      location: LocationEntity.fromJson(json['location']),
      isSold: json['isSold'],
      soldTo: json['soldTo'],
      clickCount: json['clickCount'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      owner: owner,
    );
  }
}
