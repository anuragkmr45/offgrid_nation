import '../entities/content_modal.dart';
import '../entities/comment_model.dart';
import '../entities/reply_model.dart';

abstract class ContentRepository {
  Future<(List<ContentModel>, String?)> getFeed({int limit, String? cursor});
  Future<Map<String, dynamic>> toggleLikeDislike(String postId);
  Future<List<CommentModel>> fetchComments(
    String postId, {
    int limit,
    String? cursor,
  });
  Future<CommentModel> addComment(String postId, String content);
  Future<void> toggleCommentLike(String commentId);
  Future<ReplyModel> addReply(String commentId, String content);
  Future<List<ReplyModel>> fetchReplies(
    String commentId, {
    int limit,
    String? cursor,
  });
}
