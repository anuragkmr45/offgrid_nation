class ProductEntity {
  final String id;
  final String ownerId;
  final List<String> images;
  final String title;
  final String price;
  final String condition;
  final String description;
  final String category;
  final double latitude;
  final double longitude;
  final Map<String, int> ratings;
  final int clicks;
  final DateTime createdAt;

  ProductEntity({
    required this.id,
    required this.ownerId,
    required this.images,
    required this.title,
    required this.price,
    required this.condition,
    required this.description,
    required this.category,
    required this.latitude,
    required this.longitude,
    required this.ratings,
    required this.clicks,
    required this.createdAt,
  });
  String extractOwnerId(dynamic ownerField) {
  if (ownerField is String) return ownerField;
  if (ownerField is Map<String, dynamic>) {
    return ownerField['userId'] ?? ownerField['_id'] ?? '';
  }
  return '';
}


  factory ProductEntity.fromJson(Map<String, dynamic> json) {
    final coords = json['location']?['coordinates'];
    double lat = 0.0;
    double lng = 0.0;

    try {
      if (coords is List && coords.length >= 2) {
        lng = (coords[0] as num).toDouble();
        lat = (coords[1] as num).toDouble();
      } else if (coords is Map) {
        lat = double.tryParse(coords['lat'].toString()) ?? 0.0;
        lng = double.tryParse(coords['lng'].toString()) ?? 0.0;
      }
    } catch (e) {
      print('❌ Failed to parse coordinates: $coords → $e');
    }

    final dynamic categoryRaw = json['category'];
    final String categoryId =
        categoryRaw is String ? categoryRaw : (categoryRaw['_id'] ?? '');

    return ProductEntity(
      id: json['_id'] ?? '',
      ownerId:
          json['owner'] is Map
              ? (json['owner']['userId'] ?? json['owner']['_id'] ?? '')
              : json['owner'] ?? '',
      images: List<String>.from(json['images'] ?? []),
      title: json['title'] ?? '',
      price: json['price'].toString(),
      condition: json['condition'] ?? '',
      description: json['description'] ?? '',
      category: categoryId,
      latitude: lat,
      longitude: lng,
      ratings: {}, // no API field yet
      clicks: json['clickCount'] ?? 0,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
    );
  }
}
