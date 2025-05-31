part of '../user_profile_bloc.dart';

enum UserProfileStatus {
  initial,
  loading,
  loaded,
  updated,
  photoUploading,
  photoUpdated,
  failure,
  success,
}

class UserProfileState with EquatableMixin {
  final UserProfileStatus status;
  final Map<String, dynamic>? profileData;
  final Map<String, dynamic>? userProfileData;
  final Map<String, dynamic>? updateProfileData;
  final String? profilePictureUrl;
  final Map<String, dynamic>? followersData;
  final Map<String, dynamic>? followingData;
  final Map<String, dynamic>? blockedUsersData;
  final Map<String, dynamic>? followRequestsData;
  final Map<String, dynamic>? toggleFollowUnfollowData;
  final Map<String, dynamic>? toggleBlockUnblockData;
  final List<dynamic>? userPosts;
  final String? userPostsCursor;
  final int? userPostsLimit;
  final bool isPaginating;
  final bool hasMorePosts;
  final String? errorMessage;

  const UserProfileState({
    this.status = UserProfileStatus.initial,
    this.profileData,
    this.userProfileData,
    this.updateProfileData,
    this.profilePictureUrl,
    this.followersData,
    this.followingData,
    this.blockedUsersData,
    this.followRequestsData,
    this.toggleFollowUnfollowData,
    this.toggleBlockUnblockData,
    this.userPosts,
    this.userPostsCursor,
    this.userPostsLimit = 20,
    this.isPaginating = false,
    this.hasMorePosts = true,
    this.errorMessage,
  });

  UserProfileState copyWith({
    UserProfileStatus? status,
    Map<String, dynamic>? profileData,
    Map<String, dynamic>? userProfileData,
    Map<String, dynamic>? updateProfileData,
    String? profilePictureUrl,
    Map<String, dynamic>? followersData,
    Map<String, dynamic>? followingData,
    Map<String, dynamic>? blockedUsersData,
    Map<String, dynamic>? followRequestsData,
    Map<String, dynamic>? toggleFollowUnfollowData,
    Map<String, dynamic>? toggleBlockUnblockData,
    List<dynamic>? userPosts,
    String? userPostsCursor,
    int? userPostsLimit,
    bool? isPaginating,
    bool? hasMorePosts,
    String? errorMessage,
  }) {
    return UserProfileState(
      status: status ?? this.status,
      profileData: profileData ?? this.profileData,
      userProfileData: userProfileData ?? this.userProfileData,
      updateProfileData: updateProfileData ?? this.updateProfileData,
      profilePictureUrl: profilePictureUrl ?? this.profilePictureUrl,
      followersData: followersData ?? this.followersData,
      followingData: followingData ?? this.followingData,
      blockedUsersData: blockedUsersData ?? this.blockedUsersData,
      followRequestsData: followRequestsData ?? this.followRequestsData,
      toggleFollowUnfollowData:
          toggleFollowUnfollowData ?? this.toggleFollowUnfollowData,
      toggleBlockUnblockData:
          toggleBlockUnblockData ?? this.toggleBlockUnblockData,
      userPosts: userPosts ?? this.userPosts,
      userPostsCursor: userPostsCursor ?? this.userPostsCursor,
      userPostsLimit: userPostsLimit ?? this.userPostsLimit,
      isPaginating: isPaginating ?? this.isPaginating,
      hasMorePosts: hasMorePosts ?? this.hasMorePosts,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        status,
        profileData,
        userProfileData,
        updateProfileData,
        profilePictureUrl,
        followersData,
        followingData,
        blockedUsersData,
        followRequestsData,
        toggleFollowUnfollowData,
        toggleBlockUnblockData,
        userPosts,
        userPostsCursor,
        userPostsLimit,
        isPaginating,
        hasMorePosts,
        errorMessage,
      ];
}
