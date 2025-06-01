import 'package:offgrid_nation_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:offgrid_nation_app/features/chat/domain/entities/conversation_entity.dart';

class SearchUsersUsecase {
  final ChatRepository repository;
  SearchUsersUsecase(this.repository);

  Future<List<ConversationEntity>> call(String query) async {
    return await repository.searchUsers(query);
  }
}
