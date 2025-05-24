abstract class AuthRepository {
  // Future<String> signIn(String identifier, String password);
  Future<Map<String, dynamic>> signIn(String identifier, String password);
  Future<String> signUp(Map<String, dynamic> userData);
  Future<String> appleLogin(String idToken);
  Future<String> googleLogin(String idToken);
  Future<bool> checkUsernameAvailability(String username);
  Future<Map<String, dynamic>> sendotp(String username, String phone);
  Future<Map<String, dynamic>> verifyOTP(String phone, String otp);
  Future<Map<String, dynamic>> forgotPassword(String phone);
  Future<Map<String, dynamic>> verifyPhoneResetPassword(
    String phone,
    String otp,
  );
  Future<Map<String, dynamic>> resetPassword(String phone, String newPassword);
}
