import 'package:offgrid_nation_app/core/constants/api_constants.dart';
import 'package:offgrid_nation_app/core/errors/network_exception.dart';
import 'package:offgrid_nation_app/core/network/api_client.dart';
import 'package:offgrid_nation_app/core/session/auth_session.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/comment_model.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/reply_model.dart';

abstract class ContentRemoteDataSource {
  Future<Map<String, dynamic>> fetchFeed({int limit, String? cursor});
  Future<Map<String, dynamic>> toggleLikeDislike(String? postId);
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

class ContentRemoteDataSourceImpl implements ContentRemoteDataSource {
  final ApiClient apiClient;
  final AuthSession authSession;

  ContentRemoteDataSourceImpl({
    required this.apiClient,
    required this.authSession,
  });

  @override
  Future<Map<String, dynamic>> fetchFeed({
    int limit = 20,
    String? cursor,
  }) async {
    final token = await authSession.getSessionToken();
    if (token == null) {
      throw const NetworkException('Not authorized');
    }

    final safeLimit = limit > 5 ? 5 : limit; // Enforce max limit
    final query = {
      'limit': safeLimit.toString(),
      if (cursor != null) 'cursor': cursor,
    };

    final response = await apiClient.get(
      ApiConstants.fetchfeedEndpoint,
      headers: {'Authorization': 'Bearer $token'},
      queryParams: query,
    );

    if (response is! Map<String, dynamic>) {
      throw const NetworkException('Invalid feed response format');
    }
    return response;
  }

  @override
  Future<Map<String, dynamic>> toggleLikeDislike(String? postId) async {
    final token = await authSession.getSessionToken();
    if (token == null) throw const NetworkException('Not authorized');

    if (postId == null) throw Exception("Post Not Found");

    final endpoint = ApiConstants.toggleLikeDislikeEndpoint.replaceFirst(
      'postId',
      postId,
    );

    final response = await apiClient.post(
      endpoint,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response is! Map<String, dynamic>) {
      throw const NetworkException('Invalid like/unlike response format');
    }
    return response;
  }

  @override
  Future<List<CommentModel>> fetchComments(
    String postId, {
    int limit = 20,
    String? cursor,
  }) async {
    final token = await authSession.getSessionToken();
    if (token == null) throw const NetworkException('Not authorized');

    final endpoint = ApiConstants.fetchCommentsEndpoint.replaceFirst(
      ':postId',
      postId,
    );

    final response = await apiClient.get(
      endpoint,
      headers: {'Authorization': 'Bearer $token'},
      queryParams: {'limit': '$limit', if (cursor != null) 'cursor': cursor},
    );
    
    if (response is! Map<String, dynamic> ||
        response['comments'] is! List<dynamic>) {
      throw const NetworkException('Invalid comment response format');
    }

    return (response['comments'] as List)
        .map((e) => CommentModel.fromJson(e))
        .toList();
  }

  @override
  Future<CommentModel> addComment(String postId, String content) async {
    final token = await authSession.getSessionToken();
    if (token == null) throw const NetworkException('Not authorized');

    final endpoint = ApiConstants.addCommentEndpoint.replaceFirst(
      ':postId',
      postId,
    );

    final response = await apiClient.post(
      endpoint,
      body: {'content': content},
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response is! Map<String, dynamic>) {
      throw const NetworkException('Invalid comment response');
    }
    return CommentModel.fromJson(response);
  }

  @override
  Future<void> toggleCommentLike(String commentId) async {
    final token = await authSession.getSessionToken();
    if (token == null) throw const NetworkException('Not authorized');

    final endpoint = ApiConstants.toggleCommentLikeEndpoint.replaceFirst(
      ':commentId',
      commentId,
    );

    await apiClient.post(endpoint, headers: {'Authorization': 'Bearer $token'});
  }

  @override
  Future<ReplyModel> addReply(String commentId, String content) async {
    final token = await authSession.getSessionToken();
    if (token == null) throw const NetworkException('Not authorized');

    final endpoint = ApiConstants.addReplyEndpoint.replaceFirst(
      ':commentId',
      commentId,
    );

    final response = await apiClient.post(
      endpoint,
      body: {'content': content},
      headers: {'Authorization': 'Bearer $token'},
    );

    print("-----------responseReplyModel-------------: $response");
    if (response is! Map<String, dynamic>) {
      throw const NetworkException('Invalid reply response');
    }

    return ReplyModel.fromJson(response);
  }

  @override
  Future<List<ReplyModel>> fetchReplies(
    String commentId, {
    int limit = 20,
    String? cursor,
  }) async {
    final token = await authSession.getSessionToken();
    if (token == null) throw const NetworkException('Not authorized');

    final endpoint = ApiConstants.fetchRepliesEndpoint.replaceFirst(
      ':commentId',
      commentId,
    );

    final response = await apiClient.get(
      endpoint,
      headers: {'Authorization': 'Bearer $token'},
      queryParams: {'limit': '$limit', if (cursor != null) 'cursor': cursor},
    );

    if (response is! Map<String, dynamic> ||
        response['replies'] is! List<dynamic>) {
      throw const NetworkException('Invalid reply response format');
    }

    return (response['replies'] as List)
        .map((e) => ReplyModel.fromJson(e))
        .toList();
  }
}
