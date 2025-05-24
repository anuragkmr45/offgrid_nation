import 'package:offgrid_nation_app/features/root/domain/entities/search_user_model.dart';
import 'package:offgrid_nation_app/features/root/domain/repositories/search_repository.dart';

class FetchSearchUsersUsecase {
  final SearchUserRepository repository;
  FetchSearchUsersUsecase(this.repository);

  Future<List<SearchUserModel>> call(String query) {
    return repository.getSearchedUsers(query);
  }
}
