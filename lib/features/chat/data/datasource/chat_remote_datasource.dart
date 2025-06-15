import 'package:offgrid_nation_app/core/constants/chat_api_constants.dart';
import 'package:offgrid_nation_app/core/network/api_client.dart';
import 'package:offgrid_nation_app/core/session/auth_session.dart';
import 'package:offgrid_nation_app/core/errors/network_exception.dart';
import 'package:offgrid_nation_app/features/chat/domain/entities/chat_user_entity.dart';

abstract class ChatRemoteDataSource {
  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> body);
  Future<Map<String, dynamic>> uploadMedia(String endpoint, String filePath);
  Future<List<Map<String, dynamic>>> getMessages(
    String conversationId, {
    String? cursor,
  });
  Future<List<Map<String, dynamic>>> getConversations();
  Future<void> markConversationRead(String conversationId);
  Future<void> toggleMuteConversation(String conversationId, bool isMuted);
  Future<void> deleteConversation(String conversationId);
  Future<List<ChatUserEntity>> searchUsers(String query);
  Future<List<Map<String, dynamic>>> getMessagesByRecipient(
    String recipientId, {
    int? limit,
    String? cursor,
  });
  Future<Map<String, dynamic>> sendPostMessage({
  required String recipientId,
  required String postId,
  String? conversationId,
});

}

class ChatRemoteDataSourceImpl implements ChatRemoteDataSource {
  final ApiClient apiClient;
  final AuthSession authSession;

  ChatRemoteDataSourceImpl({
    required this.apiClient,
    required this.authSession,
  });

  @override
  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> body) async {
    final token = await authSession.getSessionToken();
    if (token == null) throw const NetworkException('Unauthorized');

    final response = await apiClient.post(
      ChatApiConstants.sendMessage,
      headers: {'Authorization': 'Bearer $token'},
      body: body,
    );

    if (response is! Map<String, dynamic>) {
      throw const NetworkException('Invalid send message response');
    }
    return response;
  }

  @override
  Future<Map<String, dynamic>> uploadMedia(
    String endpoint,
    String filePath,
  ) async {
    final token = await authSession.getSessionToken();
    if (token == null) throw const NetworkException('Unauthorized');

    final response = await apiClient.uploadMultipartFile(
      endpoint,
      fileField: 'file',
      filePath: filePath,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (!response.containsKey('url')) {
      throw const NetworkException('Media upload failed');
    }

    return response;
  }

  @override
  Future<List<Map<String, dynamic>>> getMessages(
    String conversationId, {
    String? cursor,
  }) async {
    final token = await authSession.getSessionToken();
    if (token == null) throw const NetworkException('Unauthorized');

    final url = ChatApiConstants.getMessages(conversationId, cursor: cursor);
    final response = await apiClient.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response is! List) {
      throw const NetworkException('Failed to fetch messages');
    }

    return response.cast<Map<String, dynamic>>();
  }

  @override
  Future<List<Map<String, dynamic>>> getMessagesByRecipient(
    String recipientId, {
    int? limit = 18,
    String? cursor = "",
  }) async {
    try {
      final token = await authSession.getSessionToken();
      if (token == null) throw const NetworkException('Unauthorized');

      final endpoint =
          cursor != null
              ? ChatApiConstants.getMessagesByRecipient(
                recipientId,
                limit,
                cursor,
              )
              : ChatApiConstants.getMessagesByRecipient(recipientId, limit);
      final response = await apiClient.get(
        endpoint,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response is! List) {
        throw const NetworkException('Invalid message list response');
      }

      return response.cast<Map<String, dynamic>>();
    } catch (e) {
      throw NetworkException('Failed to fetch msg: $e');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getConversations() async {
    final token = await authSession.getSessionToken();
    if (token == null) throw const NetworkException('Unauthorized');

    final response = await apiClient.get(
      ChatApiConstants.getConversations,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response is! List) {
      throw const NetworkException('Invalid conversation list response');
    }

    return response.cast<Map<String, dynamic>>();
  }

  @override
  Future<void> markConversationRead(String conversationId) async {
    final token = await authSession.getSessionToken();
    if (token == null) throw const NetworkException('Unauthorized');

    await apiClient.post(
      ChatApiConstants.markConversationRead(conversationId),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  @override
  Future<void> toggleMuteConversation(
    String conversationId,
    bool isMuted,
  ) async {
    final token = await authSession.getSessionToken();
    if (token == null) throw const NetworkException('Unauthorized');

    await apiClient.post(
      ChatApiConstants.muteConversation(conversationId),
      headers: {'Authorization': 'Bearer $token'},
      body: {'mute': isMuted},
    );
  }

  @override
  Future<void> deleteConversation(String conversationId) async {
    final token = await authSession.getSessionToken();
    if (token == null) throw const NetworkException('Unauthorized');

    await apiClient.delete(
      ChatApiConstants.deleteConversation(conversationId),
      headers: {'Authorization': 'Bearer $token'},
    );
  }

  @override
  Future<List<ChatUserEntity>> searchUsers(String query) async {
    final token = await authSession.getSessionToken();
    if (token == null) throw const NetworkException('Unauthorized');

    final url = ChatApiConstants.searchUsers(query);
    final response = await apiClient.get(
      url,
      headers: {'Authorization': 'Bearer $token'},
    );
print("++++++++++++++++++++++++++++++++++++response+++++++++++++++++ $response");
    if (response is! List) {
      throw const NetworkException('Invalid user search response');
    }

    return response.map((e) => ChatUserEntity.fromJson(e)).toList();
  }

  @override
Future<Map<String, dynamic>> sendPostMessage({
  required String recipientId,
  required String postId,
  String? conversationId,
}) async {
  final token = await authSession.getSessionToken();
  if (token == null) {
    throw const NetworkException('Not authorized');
  }

  final body = {
    'recipient': recipientId,
    'actionType': 'post',
    'postId': postId,
    if (conversationId != null) 'conversationId': conversationId,
  };

  final response = await apiClient.post(
    ChatApiConstants.sendMessage,
    headers: {'Authorization': 'Bearer $token'},
    body: body,
  );

  if (response is! Map<String, dynamic>) {
    throw const NetworkException('Invalid send message response');
  }

  return response;
}

}
