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
  List<ReplyModel> replies = []; // frontend-added list
  bool showAllReplies = false; // frontend-controlled UI flag

  /// ✅ Optional isLiked flag (for current user interaction)
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
    this.isLiked = false, // ✅ default
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    return CommentModel(
      id: json['_id'],
      postId: json['postId'],
      user: UserRef.fromJson(json['userId']),
      content: json['content'],
      likes: List<String>.from(json['likes'] ?? []),
      repliesCount: json['repliesCount'] ?? 0,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isLiked: false, // ✅ can be set from frontend logic if needed
    );
  }

  /// ✅ Add copyWith for UI updates
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
