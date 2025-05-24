import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:offgrid_nation_app/core/network/api_client.dart';
import 'package:offgrid_nation_app/core/constants/api_constants.dart';
import 'package:offgrid_nation_app/core/errors/network_exception.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/content_modal.dart';

class AuthSession {
  static const _authKey = 'authKey';
  static const _userIdKey = 'userId';

  static const _usernameKey = 'username';
  static const _fullNameKey = 'fullName';
  static const _profilePicKey = 'profilePicture';

  final FlutterSecureStorage _secureStorage;
  final ApiClient _apiClient;

  AuthSession({FlutterSecureStorage? secureStorage, ApiClient? apiClient})
    : _secureStorage = secureStorage ?? const FlutterSecureStorage(),
      _apiClient = apiClient ?? ApiClient(baseUrl: ApiConstants.baseUrl);

  Future<void> saveSessionToken(String token, String userId) async {
    await _secureStorage.write(key: _authKey, value: token);
    await _secureStorage.write(key: _userIdKey, value: userId);
  }

  Future<void> saveUserMeta({
    required String username,
    required String fullName,
    required String profilePicture,
  }) async {
    await _secureStorage.write(key: _usernameKey, value: username);
    await _secureStorage.write(key: _fullNameKey, value: fullName);
    await _secureStorage.write(key: _profilePicKey, value: profilePicture);
  }

  Future<String?> getSessionToken() async {
    return await _secureStorage.read(key: _authKey);
  }

  Future<void> clearSession() async {
    await _secureStorage.delete(key: _authKey);
    await _secureStorage.delete(key: _userIdKey);
    await _secureStorage.delete(key: _usernameKey);
    await _secureStorage.delete(key: _fullNameKey);
    await _secureStorage.delete(key: _profilePicKey);
  }

  Future<bool> isLoggedIn() async {
    final token = await getSessionToken();
    return token != null && token.isNotEmpty;
  }

  Future<String?> getCurrentUserId() async {
    return await _secureStorage.read(key: _userIdKey);
  }

  /// 🔁 Try secure storage, fallback to API
  Future<UserRef> getCurrentUserRef() async {
    String? id = await getCurrentUserId();
    String? username = await _secureStorage.read(key: _usernameKey);
    String? fullName = await _secureStorage.read(key: _fullNameKey);
    String? profilePic = await _secureStorage.read(key: _profilePicKey);

    if (id == null || username == null || profilePic == null) {
      final user = await _fetchAndStoreUserProfile();
      id = user['_id'];
      username = user['username'];
      fullName = user['fullName'];
      profilePic = user['profilePicture'];
    }

    if (id == null || username == null || profilePic == null) {
      throw Exception('UserRef metadata incomplete even after fetch');
    }

    return UserRef(
      id: id,
      username: username,
      fullName: fullName ?? username,
      profilePicture: profilePic,
    );
  }

  /// 🔗 Fallback API call to /profile
  Future<Map<String, dynamic>> _fetchAndStoreUserProfile() async {
    final token = await getSessionToken();
    if (token == null) throw const NetworkException('Not authorized');

    final response = await _apiClient.get(
      ApiConstants.getProfileEndpoint,
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response['status'] == 401) {
      throw const NetworkException('Unauthorized');
    }

    if (response == null || response is! Map<String, dynamic>) {
      throw const NetworkException('Invalid response format');
    }

    final user = response;

    if (user['_id'] != null) {
      await _secureStorage.write(key: _userIdKey, value: user['_id']);
    }
    await saveUserMeta(
      username: user['username'],
      fullName: user['fullName'] ?? user['username'],
      profilePicture: user['profilePicture'] ?? '',
    );

    return user;
  }
}
