import 'package:offgrid_nation_app/features/chat/data/datasource/chat_remote_datasource.dart';
import 'package:offgrid_nation_app/features/chat/domain/entities/chat_user_entity.dart';
import 'package:offgrid_nation_app/features/chat/domain/entities/conversation_entity.dart';
import 'package:offgrid_nation_app/features/chat/domain/entities/message_entity.dart';
import 'package:offgrid_nation_app/features/chat/domain/repositories/chat_repository.dart';

class ChatRepositoryImpl implements ChatRepository {
  final ChatRemoteDataSource remoteDataSource;

  ChatRepositoryImpl({required this.remoteDataSource});

  @override
  Future<MessageEntity> sendMessage(Map<String, dynamic> body) async {
    final result = await remoteDataSource.sendMessage(body);
    return MessageEntity.fromJson(result);
  }

  @override
  Future<List<MessageEntity>> getMessages(String conversationId, {String? cursor}) async {
    final result = await remoteDataSource.getMessages(conversationId, cursor: cursor);
    return result.map((e) => MessageEntity.fromJson(e)).toList();
  }

  @override
  Future<String> uploadMedia(String endpoint, String filePath) async {
    final response = await remoteDataSource.uploadMedia(endpoint, filePath);
    return response['url'] as String;
  }

  @override
  Future<List<ConversationEntity>> getConversations() async {
    final result = await remoteDataSource.getConversations();
    return result.map((e) => ConversationEntity.fromJson(e)).toList();
  }

  @override
  Future<void> markConversationRead(String conversationId) {
    return remoteDataSource.markConversationRead(conversationId);
  }

  @override
  Future<void> toggleMuteConversation(String conversationId, bool isMuted) {
    return remoteDataSource.toggleMuteConversation(conversationId, isMuted);
  }

  @override
  Future<void> deleteConversation(String conversationId) {
    return remoteDataSource.deleteConversation(conversationId);
  }

@override
Future<List<ChatUserEntity>> searchUsers(String query) async {
  return await remoteDataSource.searchUsers(query);
}

}
