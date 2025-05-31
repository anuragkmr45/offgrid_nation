import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';
import 'package:http_parser/http_parser.dart';
import 'package:offgrid_nation_app/core/constants/api_constants.dart';
import 'package:offgrid_nation_app/core/errors/network_exception.dart';
import 'package:offgrid_nation_app/core/network/api_client.dart';
import 'package:offgrid_nation_app/core/session/auth_session.dart';

abstract class UserProfileRemoteDataSource {
  Future<Map<String, dynamic>> getOwnProfile();
  Future<Map<String, dynamic>> getUserProfileById(String userId);
  Future<Map<String, dynamic>> updateProfile(
    String username,
    String name,
    String bio,
  );
  Future<String> updateProfilePhoto(File file);
  Future<Map<String, dynamic>> getFollowers(String userId);
  Future<Map<String, dynamic>> getFollowing(String userId);
  Future<Map<String, dynamic>> getBlockedUsers();
  Future<Map<String, dynamic>> getFollowRequestsList();
  Future<Map<String, dynamic>> updateToggleFollowUnfollow(String userId);
  Future<Map<String, dynamic>> updateToggleBlockUnblock(String userId);
  Future<Map<String, dynamic>> updateAcceptFollowRequest(String userId);
  Future<Map<String, dynamic>> getPostsByUsername(
    String username, {
    int limit,
    String? cursor,
  });
}

class UserProfileRemoteDataSourceImpl implements UserProfileRemoteDataSource {
  final ApiClient apiClient;
  final AuthSession authSession;

  UserProfileRemoteDataSourceImpl({
    required this.apiClient,
    required this.authSession,
  });

  @override
  Future<Map<String, dynamic>> getOwnProfile() async {
    try {
      final token = await authSession.getSessionToken();
      if (token == null) throw const NetworkException('Not authorized');

      final response = await apiClient.get(
        ApiConstants.getProfileEndpoint,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response['status'] == 401) {
        throw const NetworkException('Unauthorized');
      }

      if (response == null || response is! Map<String, dynamic>) {
        throw const NetworkException('Invalid response format');
      }
      return response;
    } catch (e) {
      throw NetworkException('Failed to fetch profile : $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getUserProfileById(String userId) async {
    try {
      final token = await authSession.getSessionToken();
      if (token == null) throw const NetworkException('Not authorized');

      final endpoint =
          ApiConstants.baseUrl +
          ApiConstants.viewUserEndpoint
              .replaceFirst(':username', userId)
              .toString();
      final response = await apiClient.get(
        endpoint,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response == null || response is! Map<String, dynamic>) {
        throw const NetworkException('Invalid response format');
      }

      return response;
    } catch (e) {
      throw NetworkException('Fail to get user profile by id: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateProfile(
    String username,
    String name,
    String bio,
  ) async {
    try {
      final token = await authSession.getSessionToken();
      if (token == null) throw const NetworkException('Not authorized');

      final response = await apiClient.put(
        ApiConstants.updateProfileEndpoint,
        headers: {'Authorization': 'Bearer $token'},
        body: {
          if (username.isNotEmpty) 'username': username,
          if (name.isNotEmpty) 'fullName': name,
          if (bio.isNotEmpty) 'bio': bio,
        },
      );

      if (response['message'] == null || response['profile'] == null) {
        throw const NetworkException('Unexpected response from update API');
      }

      return response;
    } catch (e) {
      throw NetworkException('Failed to update profile: $e');
    }
  }

  @override
  Future<String> updateProfilePhoto(File file) async {
    try {
      final token = await authSession.getSessionToken();
      if (token == null) throw const NetworkException('Not authorized');
      
      final uri = Uri.parse(
        '${apiClient.baseUrl}${ApiConstants.updateProfilePhotoEndpoint}',
      );
      
      final request = http.MultipartRequest('POST', uri)
        ..headers['Authorization'] = 'Bearer $token';

      var mimeType = lookupMimeType(file.path)?.split('/') ?? ['image', 'jpeg'];

      mimeType =
          mimeType[0] == 'image' && mimeType[1] == 'heic'
              ? ['image', 'jpeg']
              : mimeType;

      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          file.path,
          contentType: MediaType(mimeType[0], mimeType[1]),
        ),
      );

      final response = await request.send();
      final responseBody = await http.Response.fromStream(response);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final data = apiClient.processResponse(responseBody);
        return data['profilePictureUrl'] ?? '';
      } else {
        throw NetworkException(
          'Failed to upload profile picture',
          response.statusCode,
        );
      }
    } catch (e) {
      throw NetworkException('Failed to upload photo: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getFollowers(String userId) async {
    try {
      final token = await authSession.getSessionToken();
      if (token == null) throw const NetworkException('Not authorized');

      final response = await apiClient.get(
        ApiConstants.getFollowersEndpoint.replaceFirst(':username', userId),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response is! Map<String, dynamic>) {
        throw const NetworkException('Invalid response format');
      }

      return response;
    } catch (e) {
      throw NetworkException('Failed to fetch followers: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getFollowing(String userId) async {
    try {
      final token = await authSession.getSessionToken();
      if (token == null) throw const NetworkException('Not authorized');

      final response = await apiClient.get(
        ApiConstants.getFollowingEndpoint.replaceFirst(':username', userId),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response is! Map<String, dynamic>) {
        throw const NetworkException('Invalid response format');
      }

      return response;
    } catch (e) {
      throw NetworkException('Failed to fetch following: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getBlockedUsers() async {
    try {
      final token = await authSession.getSessionToken();
      if (token == null) throw const NetworkException('Not authorized');

      final response = await apiClient.get(
        ApiConstants.getBlockedUsersEndpoint,
        headers: {'Authorization': 'Bearer $token'},
      );
      
      if (response is! Map<String, dynamic>) {
        throw const NetworkException('Invalid response format');
      }

      return response;
    } catch (e) {
      throw NetworkException('Failed to fetch blocked user: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getFollowRequestsList() async {
    try {
      final token = await authSession.getSessionToken();
      if (token == null) throw const NetworkException('Not authorized');

      final response = await apiClient.get(
        ApiConstants.getFollowRequestEndpoint,
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response is! Map<String, dynamic>) {
        throw const NetworkException('Invalid response format');
      }

      return response;
    } catch (e) {
      throw NetworkException('Failed to fetch following requests: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateToggleFollowUnfollow(
    String username,
  ) async {
    final token = await authSession.getSessionToken();
    if (token == null) throw const NetworkException('Not authorized');

    final response = await apiClient.post(
      ApiConstants.updateToggleFollowUnfollowEndpoint.replaceFirst(
        ':username',
        username,
      ),
      headers: {'Authorization': 'Bearer $token'},
      body:
          {}, // ✅ Explicit empty JSON body to satisfy your ApiClient's encoder
    );

    if (response is! Map<String, dynamic>) {
      throw const NetworkException('Invalid response format');
    }

    return response;
  }

  @override
  Future<Map<String, dynamic>> updateToggleBlockUnblock(String userId) async {
    try {
      final token = await authSession.getSessionToken();
      if (token == null) throw const NetworkException('Not authorized');

      final response = await apiClient.post(
        ApiConstants.updateToggleBlockUnblockEndpoint.replaceFirst(
          ':username',
          userId,
        ),
        headers: {'Authorization': 'Bearer $token'},
      );

      if (response is! Map<String, dynamic>) {
        throw const NetworkException('Invalid response format');
      }

      return response;
    } catch (e) {
      throw NetworkException('Failed to update follow status: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> updateAcceptFollowRequest(String userId) async {
    try {
      final token = await authSession.getSessionToken();
      if (token == null) throw const NetworkException('Not authorized');

      final response = await apiClient.post(
        ApiConstants.updateAcceptFollowRequestEndpoint,
        headers: {'Authorization': 'Bearer $token'},
        body: {'requesterId': userId},
      );

      if (response is! Map<String, dynamic>) {
        throw const NetworkException('Invalid response format');
      }

      return response;
    } catch (e) {
      throw NetworkException('Failed to update follow status: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> getPostsByUsername(String username, {
    int limit = 20,
    String? cursor,
  }) async {
    final token = await authSession.getSessionToken();
    if (token == null) throw const NetworkException('Not authorized');

    final response = await apiClient.get(
      ApiConstants.getUserPostsEndpoint.replaceFirst(':username', username),
      headers: {'Authorization': 'Bearer $token'},
    );

    if (response is! Map<String, dynamic>) {
      throw const NetworkException('Invalid response format');
    }

    return response;
  }
}
