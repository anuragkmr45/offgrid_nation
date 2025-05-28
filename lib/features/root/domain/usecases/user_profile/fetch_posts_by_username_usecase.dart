import 'package:offgrid_nation_app/features/root/domain/repositories/user_profile_repository.dart';

class FetchPostsByUsernameUsecase {
  final UserProfileRepository repository;

  FetchPostsByUsernameUsecase(this.repository);

  Future<Map<String, dynamic>> call(
    String username, {
    int limit = 10,
    String? cursor,
  }) async {
    return await repository.getPostsByUsername(
      username,
      limit: limit,
      cursor: cursor,
    );
  }
}
