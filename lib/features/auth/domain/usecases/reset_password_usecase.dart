import 'package:offgrid_nation_app/features/auth/domain/repositories/auth_repository.dart';

class ResetPasswordUseCase {
  final AuthRepository repository;
  ResetPasswordUseCase(this.repository);

  Future<Map<String, dynamic>> forgotPasswordOTP(String phone) async {
    return await repository.forgotPassword(phone);
  }

  Future<Map<String, dynamic>> verifyPhoneResetPassword(
    String phone,
    String otp,
  ) async {
    return await repository.verifyPhoneResetPassword(phone, otp);
  }

  Future<Map<String, dynamic>> resetPassword({
    required String phone,
    required String newPassword,
  }) async {
    return await repository.resetPassword(phone, newPassword);
  }
}
