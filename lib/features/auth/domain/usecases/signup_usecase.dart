import 'package:offgrid_nation_app/features/auth/domain/repositories/auth_repository.dart';

class SignupUseCase {
  final AuthRepository repository;
  SignupUseCase(this.repository);

  Future<String> call(Map<String, dynamic> userData) async {
    return await repository.signUp(userData);
  }
}
