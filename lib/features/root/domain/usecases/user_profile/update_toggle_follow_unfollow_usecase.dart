import 'package:offgrid_nation_app/features/root/domain/repositories/user_profile_repository.dart';

class UpdateToggleFollowUnfollowUsecase {
  final UserProfileRepository repository;

  UpdateToggleFollowUnfollowUsecase(this.repository);

  Future<Map<String, dynamic>> call(String userId) async {
    return await repository.updateToggleFollowUnfollow(userId);
  }
}
