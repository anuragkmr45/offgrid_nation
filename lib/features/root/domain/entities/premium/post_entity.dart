class PostEntity {
  final String id;
  final List<String> media;
  final String content;
  final int commentsCount;
  final int likesCount;
  final bool isLiked;
  final DateTime createdAt;
  final DateTime updatedAt;

  PostEntity({
    required this.id,
    required this.media,
    required this.content,
    required this.commentsCount,
    required this.likesCount,
    required this.isLiked,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PostEntity.fromJson(Map<String, dynamic> json) {
    return PostEntity(
      id: json['_id'] ?? '',
      media: List<String>.from(json['media'] ?? []),
      content: json['content'] ?? '',
      commentsCount: json['commentsCount'] ?? 0,
      likesCount: json['likesCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      createdAt: DateTime.tryParse(json['createdAt'] ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updatedAt'] ?? '') ?? DateTime.now(),
    );
  }

  PostEntity copyWith({
    List<String>? media,
    String? content,
    int? commentsCount,
    int? likesCount,
    bool? isLiked,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return PostEntity(
      id: id,
      media: media ?? this.media,
      content: content ?? this.content,
      commentsCount: commentsCount ?? this.commentsCount,
      likesCount: likesCount ?? this.likesCount,
      isLiked: isLiked ?? this.isLiked,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
