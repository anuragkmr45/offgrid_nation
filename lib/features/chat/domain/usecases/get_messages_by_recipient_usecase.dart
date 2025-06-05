import 'package:offgrid_nation_app/features/chat/domain/entities/message_entity.dart';
import 'package:offgrid_nation_app/features/chat/domain/repositories/chat_repository.dart';

class GetMessagesByRecipientUsecase {
  final ChatRepository repository;
  GetMessagesByRecipientUsecase(this.repository);

  Future<List<MessageEntity>> call(String recipientId, int? limit, String? cursor) async {
    return await repository.getMessagesByRecipient(recipientId);
  }
}