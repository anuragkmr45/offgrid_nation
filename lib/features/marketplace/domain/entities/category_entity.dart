class CategoryEntity {
  final String id;
  final String title;
  final String imageUrl;

  CategoryEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
  });

  factory CategoryEntity.fromJson(Map<String, dynamic> json) {
    return CategoryEntity(
      id: json['_id'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}
