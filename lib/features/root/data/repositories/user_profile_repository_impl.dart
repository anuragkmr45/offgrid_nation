import 'dart:io';

import 'package:offgrid_nation_app/features/root/domain/repositories/user_profile_repository.dart';

import '../datasources/user_profile_remote_data_source.dart';

class UserProfileRepositoryImpl implements UserProfileRepository {
  final UserProfileRemoteDataSource remoteDataSource;

  UserProfileRepositoryImpl(this.remoteDataSource);

  @override
  Future<Map<String, dynamic>> getOwnProfile() async {
    return await remoteDataSource.getOwnProfile();
  }

  @override
  Future<Map<String, dynamic>> getUserProfileById(String userId) async {
    final res = await remoteDataSource.getUserProfileById(userId);
    return res;
  }

  @override
  Future<Map<String, dynamic>> updateProfile(
    String username,
    String name,
    String bio,
  ) async {
    return await remoteDataSource.updateProfile(username, name, bio);
  }

  @override
  Future<String> updateProfilePhoto(File file) async {
    return await remoteDataSource.updateProfilePhoto(file);
  }

  @override
  Future<Map<String, dynamic>> getFollowers(String userId) async {
    return await remoteDataSource.getFollowers(userId);
  }

  @override
  Future<Map<String, dynamic>> getFollowing(String userId) async {
    return await remoteDataSource.getFollowing(userId);
  }

  @override
  Future<Map<String, dynamic>> getBlockedUsers() async {
    return await remoteDataSource.getBlockedUsers();
  }

  @override
  Future<Map<String, dynamic>> getFollowRequestsList() async {
    return await remoteDataSource.getFollowRequestsList();
  }

  @override
  Future<Map<String, dynamic>> updateToggleFollowUnfollow(String userId) async {
    return await remoteDataSource.updateToggleFollowUnfollow(userId);
  }

  @override
  Future<Map<String, dynamic>> updateToggleBlockUnblock(String userId) async {
    return await remoteDataSource.updateToggleBlockUnblock(userId);
  }

  @override
  Future<Map<String, dynamic>> updateAcceptFollowRequest(String userId) async {
    return await remoteDataSource.updateAcceptFollowRequest(userId);
  }

  @override
  Future<Map<String, dynamic>> getPostsByUsername(String username, {
    int limit = 20,
    String? cursor,
  }) async {
    return await remoteDataSource.getPostsByUsername(username, limit: limit, cursor: cursor);
  }
}
