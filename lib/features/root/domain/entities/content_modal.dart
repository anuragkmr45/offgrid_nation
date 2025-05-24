class UserRef {
  final String id;
  final String username;
  final String fullName;
  final String profilePicture;

  UserRef({
    required this.id,
    required this.username,
    required this.fullName,
    required this.profilePicture,
  });

  factory UserRef.fromJson(Map<String, dynamic> json) {
    return UserRef(
      id: json['_id'],
      username: json['username'],
      fullName: json['fullName'],
      profilePicture: json['profilePicture'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'username': username,
      'fullName': fullName,
      'profilePicture': profilePicture,
    };
  }
}

class ContentModel {
  final String id;
  final UserRef user;
  final List<String> media;
  final String content;
  final String? location;
  final bool isLiked;
  final int commentsCount;
  final int likesCount;
  final DateTime createdAt;

  ContentModel({
    required this.id,
    required this.user,
    required this.media,
    required this.content,
    this.location,
    required this.isLiked,
    required this.commentsCount,
    required this.likesCount,
    required this.createdAt,
  });

  /// ✅ Deserialize from API response
  factory ContentModel.fromJson(Map<String, dynamic> json) {
    return ContentModel(
      id: json['_id'],
      user: UserRef.fromJson(json['userId']),
      media: List<String>.from(json['media']),
      content: json['content'],
      location: json['location'],
      isLiked: json['isLiked'] ?? false,
      commentsCount: json['commentsCount'] ?? 0,
      likesCount: json['likesCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  /// ✅ Create updated copy of this post (for like/unlike toggle)
  ContentModel copyWith({bool? isLiked, int? likesCount, int? commentsCount}) {
    return ContentModel(
      id: id,
      user: user,
      media: media,
      content: content,
      location: location,
      isLiked: isLiked ?? this.isLiked,
      commentsCount: commentsCount ?? this.commentsCount,
      likesCount: likesCount ?? this.likesCount, // ✅ fix
      createdAt: createdAt,
    );
  }

  /// Optional: serialize back to JSON if needed
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userId': user.toJson(),
      'media': media,
      'content': content,
      'location': location,
      'commentsCount': commentsCount,
      'likesCount': likesCount,
      'isLiked': isLiked,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
