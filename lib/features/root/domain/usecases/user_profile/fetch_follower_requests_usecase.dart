import 'package:offgrid_nation_app/features/root/domain/repositories/user_profile_repository.dart';

class FetchFollowerRequestsUsecase {
  final UserProfileRepository repository;

  FetchFollowerRequestsUsecase(this.repository);

  Future<Map<String, dynamic>> call() async {
    return await repository.getFollowRequestsList();
  }
}
