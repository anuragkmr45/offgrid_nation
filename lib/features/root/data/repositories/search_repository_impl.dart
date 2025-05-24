import 'package:offgrid_nation_app/features/root/domain/entities/search_user_model.dart';
import 'package:offgrid_nation_app/features/root/domain/repositories/search_repository.dart';
import '../datasources/search_remote_data_source.dart';

class SearchUserRepositoryImpl implements SearchUserRepository {
  final SearchUserRemoteDataSource remoteDataSource;

  SearchUserRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<SearchUserModel>> getSearchedUsers(String query) async {
    final result = await remoteDataSource.searchUsers(query);
    return result.map((json) => SearchUserModel.fromJson(json)).toList();
  }
}
