import 'dart:io';

abstract class UserProfileRepository {
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
  Future<Map<String, dynamic>> getPostsByUsername(String username, {int limit, String? cursor});
}
