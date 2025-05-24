class Post {
  final String id;
  final String userId;
  final List<String> media;
  final String content;
  final String? location;
  final List<String> likes;
  final int commentsCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  Post({
    required this.id,
    required this.userId,
    required this.media,
    required this.content,
    this.location,
    required this.likes,
    required this.commentsCount,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['_id'],
      userId: json['userId'],
      media: List<String>.from(json['media']),
      content: json['content'],
      location: json['location'],
      likes: List<String>.from(json['likes']),
      commentsCount: json['commentsCount'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
