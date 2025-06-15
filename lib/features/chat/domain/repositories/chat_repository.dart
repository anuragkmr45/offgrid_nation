import 'package:offgrid_nation_app/features/chat/domain/entities/chat_user_entity.dart';
import 'package:offgrid_nation_app/features/chat/domain/entities/message_entity.dart';
import 'package:offgrid_nation_app/features/chat/domain/entities/conversation_entity.dart';

abstract class ChatRepository {
  Future<MessageEntity> sendMessage(Map<String, dynamic> body);

  Future<List<MessageEntity>> getMessages(
    String conversationId, {
    String? cursor,
  });

  Future<List<MessageEntity>> getMessagesByRecipient(
    String conversationId, {
    int? limit,
    String? cursor,
  });

  Future<String> uploadMedia(String endpoint, String filePath);

  Future<List<ConversationEntity>> getConversations();

  Future<void> markConversationRead(String conversationId);

  Future<void> toggleMuteConversation(String conversationId, bool isMuted);

  Future<void> deleteConversation(String conversationId);

  Future<List<ChatUserEntity>> searchUsers(String query);

  Future<Map<String, dynamic>> sendPostMessage({
    required String recipientId,
    required String postId,
    String? conversationId,
  });
}
