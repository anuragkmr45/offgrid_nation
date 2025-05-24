import 'package:offgrid_nation_app/features/auth/domain/repositories/auth_repository.dart';

class VerifyOTPUseCase {
  final AuthRepository repository;

  VerifyOTPUseCase(this.repository);

  Future<Map<String, dynamic>> call(String phone, String otp) async {
    return await repository.verifyOTP(phone, otp);
  }
}
