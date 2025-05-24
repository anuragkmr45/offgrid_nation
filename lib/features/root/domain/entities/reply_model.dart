import 'package:offgrid_nation_app/features/root/domain/entities/content_modal.dart';

class ReplyModel {
  final String id;
  final String commentId;
  final UserRef user;
  final String content;
  final List<String> likes;
  final DateTime createdAt;
  final DateTime updatedAt;

  ReplyModel({
    required this.id,
    required this.commentId,
    required this.user,
    required this.content,
    required this.likes,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      id: json['_id'],
      commentId: json['commentId'],
      user: UserRef.fromJson(json['userId']),
      content: json['content'],
      likes: List<String>.from(json['likes'] ?? []),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
