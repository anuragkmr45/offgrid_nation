import 'package:offgrid_nation_app/features/root/domain/repositories/user_profile_repository.dart';

class UpdateAcceptFollowRequestUsecase {
  final UserProfileRepository repository;

  UpdateAcceptFollowRequestUsecase(this.repository);

  Future<Map<String, dynamic>> call(String userId) async {
    return await repository.updateAcceptFollowRequest(userId);
  }
}
