import 'package:offgrid_nation_app/features/root/domain/entities/comment_model.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/reply_model.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/content_modal.dart';
import 'package:offgrid_nation_app/features/root/domain/repositories/content_repository.dart';
import '../datasources/content_remote_data_source.dart';

class ContentRepositoryImpl implements ContentRepository {
  final ContentRemoteDataSource remote;

  ContentRepositoryImpl(this.remote);

  @override
  Future<(List<ContentModel>, String?)> getFeed({
    int limit = 20,
    String? cursor,
  }) async {
    final json = await remote.fetchFeed(limit: limit, cursor: cursor);
    final posts = (json['posts'] as List)
        .map((e) => ContentModel.fromJson(e))
        .toList(growable: false);
    final nextCursor = json['nextCursor'] as String?;
    return (posts, nextCursor);
  }

  @override
  Future<Map<String, dynamic>> toggleLikeDislike(String postId) async {
    return await remote.toggleLikeDislike(postId);
  }

  @override
  Future<List<CommentModel>> fetchComments(
    String postId, {
    int limit = 20,
    String? cursor,
  }) async {
    return await remote.fetchComments(postId, limit: limit, cursor: cursor);
  }

  @override
  Future<CommentModel> addComment(String postId, String content) async {
    final a = await remote.addComment(postId, content);
    return a;
  }

  @override
  Future<void> toggleCommentLike(String commentId) async {
    return await remote.toggleCommentLike(commentId);
  }

  @override
  Future<ReplyModel> addReply(String commentId, String content) async {
    return await remote.addReply(commentId, content);
  }

  @override
  Future<List<ReplyModel>> fetchReplies(
    String commentId, {
    int limit = 20,
    String? cursor,
  }) async {
    return await remote.fetchReplies(commentId, limit: limit, cursor: cursor);
  }

  @override
  Future<Map<String, dynamic>> sendPostMessage({
    required String recipientId,
    required String postId,
    String? conversationId,
  }) {
    return remote.sendPostMessage(
      recipientId: recipientId,
      postId: postId,
      conversationId: conversationId,
    );
  }
}
