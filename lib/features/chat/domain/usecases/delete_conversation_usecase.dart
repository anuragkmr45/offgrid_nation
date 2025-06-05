import 'package:offgrid_nation_app/features/chat/domain/repositories/chat_repository.dart';

class DeleteConversationUsecase {
  final ChatRepository repository;
  DeleteConversationUsecase(this.repository);

  Future<void> call(String conversationId) async {
    await repository.deleteConversation(conversationId);
  }
}