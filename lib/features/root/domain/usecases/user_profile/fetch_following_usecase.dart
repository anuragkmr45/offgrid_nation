import 'package:offgrid_nation_app/features/root/domain/repositories/user_profile_repository.dart';

class FetchFollowingUsecase {
  final UserProfileRepository repository;

  FetchFollowingUsecase(this.repository);

  Future<Map<String, dynamic>> call(String userId) async {
    return await repository.getFollowing(userId);
  }
}
