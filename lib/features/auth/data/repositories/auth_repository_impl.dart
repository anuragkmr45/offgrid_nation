import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:offgrid_nation_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:offgrid_nation_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:offgrid_nation_app/core/session/auth_session.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final AuthRemoteDataSource remoteDataSource;
  final FlutterSecureStorage secureStorage;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.secureStorage,
  }) : _firebaseAuth = FirebaseAuth.instance;

  // @override
  // Future<String> signIn(String identifier, String password) async {
  //   final response = await remoteDataSource.signIn(identifier, password);
  //   final token = response['token'] as String?;
  //   final userId = response['user']?['_id'] as String?;

  //   if (token == null || userId == null) {
  //     throw Exception("Missing token or userId in response.");
  //   }

  //   await AuthSession(
  //     secureStorage: secureStorage,
  //   ).saveSessionToken(token, userId);

  //   return token;
  // }
  @override
  Future<Map<String, dynamic>> signIn(
    String identifier,
    String password,
  ) async {
    final response = await remoteDataSource.signIn(identifier, password);
    final token = response['token'];
    final user = response['user'];

    await secureStorage.write(key: 'authKey', value: token);
    await secureStorage.write(key: 'userId', value: user['_id']);

    return {
      'token': token,
      'username': user['username'],
      'fullName': user['fullName'] ?? user['username'],
      'profilePicture': user['profilePicture'] ?? '',
    };
  }

  @override
  Future<String> signUp(Map<String, dynamic> userData) async {
    final response = await remoteDataSource.signUp(userData);

    if (!response.containsKey('user')) {
      throw Exception("User data not found in signUp response.");
    }

    return response['user']['_id'] ?? 'success';
  }

  @override
  Future<String> appleLogin(String idToken) async {
    final response = await remoteDataSource.appleLogin(idToken);
    final authKey = response['token'] as String?;
    if (authKey == null) {
      throw Exception("Authentication key not found in response.");
    }
    await secureStorage.write(key: 'authKey', value: authKey);
    return authKey;
  }

  @override
  Future<String> googleLogin(String idToken) async {
    final response = await remoteDataSource.googleLogin(idToken);
    final authKey = response['token'] as String?;
    if (authKey == null) {
      throw Exception("Authentication key not found in response.");
    }
    await secureStorage.write(key: 'authKey', value: authKey);
    return authKey;
  }

  @override
  Future<bool> checkUsernameAvailability(String username) async {
    final response = await remoteDataSource.checkUsernameAvailability(username);
    return response;
  }

  @override
  Future<Map<String, dynamic>> sendotp(String username, String phone) async {
    final response = await remoteDataSource.sendOTP(username, phone);
    return response;
  }

  @override
  Future<Map<String, dynamic>> verifyOTP(String phone, String otp) async {
    final response = await remoteDataSource.verifyOTP(phone, otp);
    return response;
  }

  @override
  Future<Map<String, dynamic>> forgotPassword(String phone) async {
    return await remoteDataSource.forgotPassword(phone);
  }

  @override
  Future<Map<String, dynamic>> verifyPhoneResetPassword(
    String phone,
    String otp,
  ) async {
    return await remoteDataSource.verifyPhoneResetPassword(phone, otp);
  }

  @override
  Future<Map<String, dynamic>> resetPassword(
    String phone,
    String newPassword,
  ) async {
    final response = await remoteDataSource.resetPassword(phone, newPassword);
    return response;
  }
}
