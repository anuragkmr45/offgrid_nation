import 'package:offgrid_nation_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:offgrid_nation_app/features/chat/domain/entities/conversation_entity.dart';

class GetConversationsUsecase {
  final ChatRepository repository;
  GetConversationsUsecase(this.repository);

  Future<List<ConversationEntity>> call() async {
    return await repository.getConversations();
  }
}
