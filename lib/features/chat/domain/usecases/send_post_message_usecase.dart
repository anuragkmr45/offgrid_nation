import 'package:offgrid_nation_app/features/chat/domain/repositories/chat_repository.dart';

class SendPostMessageUsecase {
  final ChatRepository repository;

  SendPostMessageUsecase(this.repository);

  Future<Map<String, dynamic>> call({
    required String recipientId,
    required String postId,
    String? conversationId,
  }) {
    return repository.sendPostMessage(
      recipientId: recipientId,
      postId: postId,
      conversationId: conversationId,
    );
  }
}
