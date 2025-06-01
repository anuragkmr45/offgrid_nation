import 'package:equatable/equatable.dart';
import 'chat_user_entity.dart';

class PostPayloadEntity extends Equatable {
  final String id;
  final ChatUserEntity user;
  final List<String> media;
  final String content;
  final String location;
  final int commentsCount;
  final int likesCount;
  final bool isLiked;
  final bool isFollowing;
  final DateTime createdAt;
  final DateTime updatedAt;

  const PostPayloadEntity({
    required this.id,
    required this.user,
    required this.media,
    required this.content,
    required this.location,
    required this.commentsCount,
    required this.likesCount,
    required this.isLiked,
    required this.isFollowing,
    required this.createdAt,
    required this.updatedAt,
  });

  factory PostPayloadEntity.fromJson(Map<String, dynamic> json) {
    return PostPayloadEntity(
      id: json['_id'],
      user: ChatUserEntity.fromJson(json['userId']),
      media: (json['media'] as List<dynamic>).cast<String>(),
      content: json['content'],
      location: json['location'],
      commentsCount: json['commentsCount'] ?? 0,
      likesCount: json['likesCount'] ?? 0,
      isLiked: json['isLiked'] ?? false,
      isFollowing: json['isFollowing'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }

  @override
  List<Object?> get props => [
        id,
        user,
        media,
        content,
        location,
        commentsCount,
        likesCount,
        isLiked,
        isFollowing,
        createdAt,
        updatedAt,
      ];
}
