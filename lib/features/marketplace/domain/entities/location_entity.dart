// lib/features/marketplace/domain/entities/location_entity.dart
class LocationEntity {
  final List<double> coordinates;

  LocationEntity({required this.coordinates});

  factory LocationEntity.fromJson(Map<String, dynamic> json) {
    return LocationEntity(coordinates: List<double>.from(json['coordinates']));
  }
}
