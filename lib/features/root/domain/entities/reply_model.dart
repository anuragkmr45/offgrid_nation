import 'package:offgrid_nation_app/features/root/domain/entities/content_modal.dart';

class ReplyModel {
  final String id;
  final String commentId;
  final UserRef user;
  final String content;
  final DateTime createdAt;

  ReplyModel({
    required this.id,
    required this.commentId,
    required this.user,
    required this.content,
    required this.createdAt,
  });

  factory ReplyModel.fromJson(Map<String, dynamic> json) {
    return ReplyModel(
      id: json['_id'],
      commentId: json['commentId'],
      user: UserRef.fromJson(json['userId']),
      content: json['content'],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }
}
