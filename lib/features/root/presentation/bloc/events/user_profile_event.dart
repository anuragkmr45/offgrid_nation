part of '../user_profile_bloc.dart';

@immutable
sealed class UserProfileEvent extends Equatable {
  const UserProfileEvent();

  @override
  List<Object?> get props => [];
}

class FetchProfileRequested extends UserProfileEvent {
  final String? username;
  final int limit;
  final String? cursor;
  const FetchProfileRequested({
    this.username,
    required this.limit,
    this.cursor,
  });

  @override
  List<Object?> get props => [username, limit, cursor];
}

class FetchUserProfileById extends UserProfileEvent {
  final String userId;
  const FetchUserProfileById(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateProfileRequest extends UserProfileEvent {
  final String username;
  final String name;
  final String bio;

  const UpdateProfileRequest({
    required this.username,
    required this.name,
    required this.bio,
  });

  @override
  List<Object?> get props => [username, name, bio];
}

class UpdateProfilePhotoRequest extends UserProfileEvent {
  final File file;

  const UpdateProfilePhotoRequest({required this.file});

  @override
  List<Object?> get props => [file];
}

class FetchFollowersRequest extends UserProfileEvent {
  final String userId;
  const FetchFollowersRequest(this.userId);

  @override
  List<Object?> get props => [userId];
}

class FetchFollowingRequest extends UserProfileEvent {
  final String userId;
  const FetchFollowingRequest(this.userId);

  @override
  List<Object?> get props => [userId];
}

class FetchBlockedUserRequest extends UserProfileEvent {
  const FetchBlockedUserRequest();

  @override
  List<Object?> get props => [];
}

class FetchFollowRequestsListRequest extends UserProfileEvent {
  const FetchFollowRequestsListRequest();

  @override
  List<Object?> get props => [];
}

class UpdateToggleFollowUnfollowRequest extends UserProfileEvent {
  final String userId;
  const UpdateToggleFollowUnfollowRequest(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateToggleBlockUnblockRequest extends UserProfileEvent {
  final String userId;
  const UpdateToggleBlockUnblockRequest(this.userId);

  @override
  List<Object?> get props => [userId];
}

class UpdateAcceptFollowRequest extends UserProfileEvent {
  final String requesterId;
  const UpdateAcceptFollowRequest(this.requesterId);

  @override
  List<Object?> get props => [requesterId];
}

class FetchPostsByUsername extends UserProfileEvent {
  final String username;
  final int limit;
  final String? cursor;

  const FetchPostsByUsername({
    required this.username,
    this.limit = 20,
    this.cursor,
  });

  @override
  List<Object?> get props => [username, limit, cursor];
}
