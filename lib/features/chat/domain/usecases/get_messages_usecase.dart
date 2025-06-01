import 'package:offgrid_nation_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:offgrid_nation_app/features/chat/domain/entities/message_entity.dart';

class GetMessagesUsecase {
  final ChatRepository repository;
  GetMessagesUsecase(this.repository);

  Future<List<MessageEntity>> call(String conversationId, {String? cursor}) async {
    return await repository.getMessages(conversationId, cursor: cursor);
  }
}
