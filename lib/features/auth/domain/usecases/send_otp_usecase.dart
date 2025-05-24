import 'package:offgrid_nation_app/features/auth/domain/repositories/auth_repository.dart';

class SendOTPUseCase {
  final AuthRepository repository;

  SendOTPUseCase(this.repository);

  Future<Map<String, dynamic>> call(String username, String phone) async {
    return await repository.sendotp(username, phone);
  }
}
