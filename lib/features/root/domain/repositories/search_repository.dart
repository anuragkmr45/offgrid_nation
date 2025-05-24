import 'package:offgrid_nation_app/features/root/domain/entities/search_user_model.dart';

abstract class SearchUserRepository {
  Future<List<SearchUserModel>> getSearchedUsers(String query);
}
