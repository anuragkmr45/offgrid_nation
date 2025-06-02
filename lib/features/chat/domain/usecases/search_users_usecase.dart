import 'package:offgrid_nation_app/features/chat/domain/entities/chat_user_entity.dart';
import 'package:offgrid_nation_app/features/chat/domain/repositories/chat_repository.dart';

class SearchUsersUsecase {
  final ChatRepository repository;
  SearchUsersUsecase(this.repository);

  Future<List<ChatUserEntity>> call(String query) async {
    return await repository.searchUsers(query);
  }
}
