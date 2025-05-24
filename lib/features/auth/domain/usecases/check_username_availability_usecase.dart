import 'package:offgrid_nation_app/features/auth/domain/repositories/auth_repository.dart';

class CheckUsernameAvailabilityUseCase {
  final AuthRepository repository;

  CheckUsernameAvailabilityUseCase(this.repository);

  Future<bool> call(String username) async {
    return await repository.checkUsernameAvailability(username);
  }
}
