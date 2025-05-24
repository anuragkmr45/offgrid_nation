import 'package:offgrid_nation_app/features/root/domain/repositories/user_profile_repository.dart';

class FetchBlockedUsersUsecase {
  final UserProfileRepository repository;

  FetchBlockedUsersUsecase(this.repository);

  Future<Map<String, dynamic>> call() async {
    return await repository.getBlockedUsers();
  }
}
