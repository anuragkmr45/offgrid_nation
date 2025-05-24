import 'package:offgrid_nation_app/features/root/domain/repositories/user_profile_repository.dart';

class UpdateProfileUsecase {
  final UserProfileRepository repository;

  UpdateProfileUsecase(this.repository);

  Future<Map<String, dynamic>> call(
    String username,
    String name,
    String bio,
  ) async {
    return await repository.updateProfile(username, name, bio);
  }
}
