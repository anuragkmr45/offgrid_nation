import 'package:offgrid_nation_app/features/root/domain/repositories/content_repository.dart';

class SendPostMessageUsecase {
  final ContentRepository repository;

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
