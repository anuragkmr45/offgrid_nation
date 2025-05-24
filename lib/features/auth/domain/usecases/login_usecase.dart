import 'package:offgrid_nation_app/features/auth/domain/repositories/auth_repository.dart';

// class LoginUseCase {
//   final AuthRepository repository;
//   LoginUseCase(this.repository);

//   Future<String> call(String identifier, String password) async {
//     return await repository.signIn(identifier, password);
//   }
// }
class LoginUseCase {
  final AuthRepository repository;
  LoginUseCase(this.repository);

  Future<Map<String, dynamic>> call(String identifier, String password) async {
    return await repository.signIn(identifier, password);
  }
}
