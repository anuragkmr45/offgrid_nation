import 'package:firebase_auth/firebase_auth.dart';
import 'package:offgrid_nation_app/core/constants/api_constants.dart';
import 'package:offgrid_nation_app/core/errors/network_exception.dart';
import 'package:offgrid_nation_app/core/network/api_client.dart';

abstract class AuthRemoteDataSource {
  Future<Map<String, dynamic>> signIn(String identifier, String password);
  Future<Map<String, dynamic>> signUp(Map<String, dynamic> userData);
  Future<Map<String, dynamic>> appleLogin(String token);
  Future<Map<String, dynamic>> googleLogin(String token);
  Future<bool> checkUsernameAvailability(String username);
  Future<Map<String, dynamic>> sendOTP(String username, String phone);
  Future<Map<String, dynamic>> verifyOTP(String phone, String otp);
  Future<Map<String, dynamic>> forgotPassword(String phone);
  Future<Map<String, dynamic>> verifyPhoneResetPassword(
    String phone,
    String otp,
  );
  Future<Map<String, dynamic>> resetPassword(String phone, String newPassword);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient apiClient;
  final FirebaseAuth firebaseAuth;

  AuthRemoteDataSourceImpl({
    required this.apiClient,
    FirebaseAuth? firebaseAuth,
  }) : firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  @override
  Future<Map<String, dynamic>> signIn(
    String identifier,
    String password,
  ) async {
    try {
      final response = await apiClient.post(
        ApiConstants.signInEndpoint,
        body: {"loginId": identifier, "password": password},
      );

      if (response is! Map<String, dynamic>) {
        throw const NetworkException('Invalid signin response format');
      }

      return response;
    } catch (e) {
      throw NetworkException('Failed to sign in: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> signUp(Map<String, dynamic> userData) async {
    try {
      final response = await apiClient.post(
        ApiConstants.signUpEndpoint,
        body: userData,
      );
      if (response is! Map<String, dynamic>) {
        throw const NetworkException('Invalid signUp response format');
      }
      return response;
    } catch (e) {
      throw NetworkException('Failed to sign up: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> appleLogin(String idToken) async {
    try {
      final response = await apiClient.post(
        ApiConstants.socialLoginEndpoint,
        body: {'firebaseIdToken': idToken, 'provider': 'apple'},
      );

      if (response is! Map<String, dynamic>) {
        throw const NetworkException('Invalid response format');
      }

      return response;
    } catch (e) {
      throw NetworkException('Failed apple login: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> googleLogin(String idToken) async {
    try {
      final endpoint = ApiConstants.baseUrl + ApiConstants.socialLoginEndpoint;
      final response = await apiClient.post(
        endpoint,
        body: {'idToken': idToken},
      );

      if (response is! Map<String, dynamic>) {
        throw const NetworkException('Invalid response format');
      }

      return response;
    } catch (e) {
      throw NetworkException('Failed Google login: $e');
    }
  }

  @override
  Future<bool> checkUsernameAvailability(String username) async {
    try {
      final response = await apiClient.get(
        ApiConstants.usernameValidationEndpoint,
        queryParams: {'username': username},
      );
      final exists = response['exists'] as bool? ?? true;
      return exists;
    } catch (e) {
      throw NetworkException('Failed to check username availability: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> sendOTP(String username, String phone) async {
    try {
      final response = await apiClient.post(
        ApiConstants.sendotp,
        body: {'username': username, 'mobile': phone},
      );
      if (response is! Map<String, dynamic>) {
        throw const NetworkException('Invalid response format');
      }
      return response;
    } catch (e) {
      throw NetworkException('Failed to send OTP: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> verifyOTP(String phone, String otp) async {
    try {
      final response = await apiClient.post(
        ApiConstants.verifyotp,
        body: {'mobile': phone, 'otp': otp},
      );
      if (response is! Map<String, dynamic>) {
        throw const NetworkException('Invalid response format');
      }

      return response;
    } catch (e) {
      throw NetworkException('Unexpected OTP error: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(String phone) async {
    try {
      final response = await apiClient.post(
        ApiConstants.forgotPasswordEndpoint,
        body: {'mobile': phone},
      );
      if (response is! Map<String, dynamic>) {
        throw const NetworkException('Invalid forgot-password response format');
      }

      return response;
    } catch (e) {
      throw NetworkException('Failed to send otp for reset-pass: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> verifyPhoneResetPassword(
    String phone,
    String otp,
  ) async {
    try {
      final response = await apiClient.post(
        ApiConstants.verifyPhoneResetPasswordEndpoint,
        body: {'mobile': phone, 'otp': otp},
      );
      if (response is! Map<String, dynamic>) {
        throw const NetworkException(
          'Invalid Verify phone number reset password response format',
        );
      }

      return response;
    } catch (e) {
      throw NetworkException('Failed to verify otp: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> resetPassword(
    String phone,
    String newPassword,
  ) async {
    try {
      final response = await apiClient.post(
        ApiConstants.resetPasswordEndpoint,
        body: {'mobile': phone, 'newPassword': newPassword},
      );

      if (response is! Map<String, dynamic>) {
        throw const NetworkException(
          'Invalid Verify phone number reset password response format',
        );
      }

      return response;
    } catch (e) {
      throw NetworkException('Failed to reset password: $e');
    }
  }
}
