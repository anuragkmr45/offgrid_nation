import 'package:offgrid_nation_app/features/chat/domain/repositories/chat_repository.dart';

class MuteConversationUsecase {
  final ChatRepository repository;
  MuteConversationUsecase(this.repository);

  Future<void> call(String conversationId, bool isMuted) async {
    await repository.toggleMuteConversation(conversationId, isMuted);
  }
}