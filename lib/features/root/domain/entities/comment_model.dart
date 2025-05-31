import 'package:offgrid_nation_app/features/root/domain/entities/content_modal.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/reply_model.dart';

class CommentModel {
  final String id;
  final String postId;
  final UserRef user;
  final String content;
  final List<String> likes;
  final int repliesCount;
  final DateTime createdAt;
  final DateTime updatedAt;
  List<ReplyModel> replies = [];
  bool showAllReplies = false;
  final bool isLiked;

  CommentModel({
    required this.id,
    required this.postId,
    required this.user,
    required this.content,
    required this.likes,
    required this.repliesCount,
    required this.createdAt,
    required this.updatedAt,
    this.isLiked = false,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final latestRepliesJson = json['latestReplies'] as List<dynamic>? ?? [];
    final parsedReplies =
        latestRepliesJson
            .map(
              (e) => ReplyModel(
                commentId: json['_id'],
                content: e['replyContent'],
                createdAt: DateTime.parse(e['createdAt']),
                user: UserRef(
                  id: e['userId'],
                  username: e['username'] ?? '',
                  fullName: e['fullName'] ?? '',
                  profilePicture: e['profilePicture'] ?? '',
                ), id: ''
              ),
            )
            .toList();

    return CommentModel(
      id: json['_id'],
      postId: json['postId'],
      user: UserRef.fromJson(json['userId']),
      content: json['content'],
      likes: List<String>.from(json['likes'] ?? []),
      repliesCount: json['repliesCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isLiked: false,
    )..replies = parsedReplies;
  }

  CommentModel copyWith({
    List<String>? likes,
    int? repliesCount,
    bool? isLiked,
    List<ReplyModel>? replies,
    bool? showAllReplies,
  }) {
    return CommentModel(
        id: id,
        postId: postId,
        user: user,
        content: content,
        likes: likes ?? this.likes,
        repliesCount: repliesCount ?? this.repliesCount,
        createdAt: createdAt,
        updatedAt: updatedAt,
        isLiked: isLiked ?? this.isLiked,
      )
      ..replies = replies ?? this.replies
      ..showAllReplies = showAllReplies ?? this.showAllReplies;
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'postId': postId,
      'userId': user.toJson(),
      'content': content,
      'likes': likes,
      'repliesCount': repliesCount,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }
}
