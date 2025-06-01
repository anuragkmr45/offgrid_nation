import 'package:offgrid_nation_app/features/chat/domain/repositories/chat_repository.dart';

class MarkConversationReadUsecase {
  final ChatRepository repository;
  MarkConversationReadUsecase(this.repository);

  Future<void> call(String conversationId) async {
    await repository.markConversationRead(conversationId);
  }
}