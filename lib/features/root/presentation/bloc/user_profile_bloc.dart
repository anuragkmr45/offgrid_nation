import 'dart:io';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart' show immutable;
import 'package:offgrid_nation_app/core/errors/error_handler.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/fetch_posts_by_username_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/fetch_profile_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/fetch_user_profile_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/update_accept_follow_request_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/update_profile_photo_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/update_profile_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/fetch_follower_requests_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/fetch_following_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/fetch_followers_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/fetch_blocked_users_usecase.dart';
// import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/update_toggle_block_unblock_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/update_toggle_follow_unfollow_usecase.dart';
// import 'package:offgrid_nation_app/features/root/presentation/bloc/events/user_profile_event.dart';
// import 'package:offgrid_nation_app/features/root/presentation/bloc/states/user_profile_state.dart';

part 'events/user_profile_event.dart';
part 'states/user_profile_state.dart';

class UserProfileBloc extends Bloc<UserProfileEvent, UserProfileState> {
  final FetchProfileUsecase fetchProfileUsecase;
  final FetchUserProfileUsecase fetchUserProfileUsecase;
  final UpdateProfileUsecase updateProfileUsecase;
  final UpdateProfilePhotoUsecase updateProfilePhotoUsecase;
  final FetchFollowersUsecase fetchFollowersUsecase;
  final FetchFollowingUsecase fetchFollowingUsecase;
  final FetchFollowerRequestsUsecase fetchFollowerRequestsUsecase;
  final FetchBlockedUsersUsecase fetchBlockedUsersUsecase;
  final UpdateAcceptFollowRequestUsecase updateAcceptFollowRequestUsecase;
  // final UpdateToggleBlockUnblockUsecase updateToggleBlockUnblockUsecase;
  final UpdateToggleFollowUnfollowUsecase updateToggleFollowUnfollowUsecase;
  final FetchPostsByUsernameUsecase fetchPostsByUsernameUsecase;

  UserProfileBloc({
    required this.fetchProfileUsecase,
    required this.fetchUserProfileUsecase,
    required this.updateProfileUsecase,
    required this.updateProfilePhotoUsecase,
    required this.fetchBlockedUsersUsecase,
    required this.fetchFollowerRequestsUsecase,
    required this.fetchFollowersUsecase,
    required this.fetchFollowingUsecase,
    required this.updateAcceptFollowRequestUsecase,
    // required this.updateToggleBlockUnblockUsecase,
    required this.updateToggleFollowUnfollowUsecase,
    required this.fetchPostsByUsernameUsecase,
  }) : super(const UserProfileState()) {
    on<FetchProfileRequested>(_onFetchOwnProfile);
    on<FetchUserProfileById>(_onFetchUserProfileById);
    on<UpdateProfileRequest>(_onUpdateProfile);
    on<UpdateProfilePhotoRequest>(_onUpdateProfilePhoto);
    on<FetchFollowersRequest>(_onFetchFollowersRequest);
    on<FetchFollowingRequest>(_onFetchFollowingRequest);
    on<FetchBlockedUserRequest>(_onFetchBlockedUserRequest);
    on<FetchFollowRequestsListRequest>(_onFetchFollowRequestsListRequest);
    on<UpdateToggleFollowUnfollowRequest>(_onUpdateToggleFollowUnfollowRequest);
    // on<UpdateToggleBlockUnblockRequest>(_onUpdateToggleBlockUnblockRequest);
    on<FetchPostsByUsername>(_onFetchPostsByUsername);
  }

  Future<void> _onFetchOwnProfile(
    FetchProfileRequested event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(state.copyWith(status: UserProfileStatus.loading));
    try {
      final profile = await fetchProfileUsecase();
      emit(
        state.copyWith(status: UserProfileStatus.success, profileData: profile),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: UserProfileStatus.failure,
          errorMessage: ErrorHandler.handle(error),
        ),
      );
    }
  }

  Future<void> _onFetchUserProfileById(
    FetchUserProfileById event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(state.copyWith(status: UserProfileStatus.loading));
    try {
      final data = await fetchUserProfileUsecase(event.userId);
      emit(
        state.copyWith(status: UserProfileStatus.success, profileData: data),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: UserProfileStatus.failure,
          errorMessage: ErrorHandler.handle(error),
        ),
      );
    }
  }

  Future<void> _onUpdateProfile(
    UpdateProfileRequest event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(state.copyWith(status: UserProfileStatus.loading));
    try {
      final data = await updateProfileUsecase(
        event.username,
        event.name,
        event.bio,
      );

      final isSuccess = data['message'].toString().contains("successfully");

      if (isSuccess) {
        final refreshedProfile = await fetchProfileUsecase();
        emit(
          state.copyWith(
            status: UserProfileStatus.success,
            updateProfileData: data,
            profileData: refreshedProfile,
          ),
        );
      }
    } catch (error) {
      emit(
        state.copyWith(
          status: UserProfileStatus.failure,
          errorMessage: ErrorHandler.handle(error),
        ),
      );
    }
  }

  Future<void> _onUpdateProfilePhoto(
    UpdateProfilePhotoRequest event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(state.copyWith(status: UserProfileStatus.loading));
    try {
      final data = await updateProfilePhotoUsecase(event.file);
      emit(
        state.copyWith(
          status: UserProfileStatus.success,
          profilePictureUrl: data,
          profileData: {...state.profileData ?? {}, 'profilePicture': data},
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: UserProfileStatus.failure,
          errorMessage: ErrorHandler.handle(error),
        ),
      );
    }
  }

  Future<void> _onFetchFollowersRequest(
    FetchFollowersRequest event,
    Emitter<UserProfileState> emit,
  ) async {
    // emit(state.copyWith(status: UserProfileStatus.loading));
    try {
      final data = await fetchFollowersUsecase(event.userId);
      emit(
        state.copyWith(
          // status: UserProfileStatus.success,
          followersData: data,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          // status: UserProfileStatus.failure,
          errorMessage: ErrorHandler.handle(error),
        ),
      );
    }
  }

  Future<void> _onFetchFollowingRequest(
    FetchFollowingRequest event,
    Emitter<UserProfileState> emit,
  ) async {
    // emit(state.copyWith(status: UserProfileStatus.loading));
    try {
      final fetchfollowing = await fetchFollowingUsecase(event.userId);
      emit(
        state.copyWith(
          // status: UserProfileStatus.success,
          followingData: fetchfollowing,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          // status: UserProfileStatus.failure,
          errorMessage: ErrorHandler.handle(error),
        ),
      );
    }
  }

  Future<void> _onFetchBlockedUserRequest(
    FetchBlockedUserRequest event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(state.copyWith(status: UserProfileStatus.loading));
    try {
      final blockedUsers = await fetchBlockedUsersUsecase();
      emit(
        state.copyWith(
          status: UserProfileStatus.success,
          blockedUsersData: blockedUsers,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: UserProfileStatus.failure,
          errorMessage: ErrorHandler.handle(error),
        ),
      );
    }
  }

  Future<void> _onFetchFollowRequestsListRequest(
    FetchFollowRequestsListRequest event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(state.copyWith(status: UserProfileStatus.loading));
    try {
      final followRequests = await fetchFollowerRequestsUsecase();
      emit(
        state.copyWith(
          status: UserProfileStatus.success,
          followRequestsData: followRequests,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: UserProfileStatus.failure,
          errorMessage: ErrorHandler.handle(error),
        ),
      );
    }
  }

  Future<void> _onUpdateToggleFollowUnfollowRequest(
    UpdateToggleFollowUnfollowRequest event,
    Emitter<UserProfileState> emit,
  ) async {
    emit(state.copyWith(status: UserProfileStatus.loading));
    try {
      final data = await updateToggleFollowUnfollowUsecase(event.userId);
      emit(
        state.copyWith(
          status: UserProfileStatus.success,
          toggleFollowUnfollowData: data,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          status: UserProfileStatus.failure,
          errorMessage: ErrorHandler.handle(error),
        ),
      );
    }
  }

  // Future<void> _onUpdateToggleBlockUnblockReques(
  //   UpdateToggleBlockUnblockRequest event,
  //   Emitter<UserProfileState> emit,
  // ) async {
  //   emit(state.copyWith(status: UserProfileStatus.loading));
  //   try {
  //     final data = await updateToggleBlockUnblockUsecase(event.userId);
  //     emit(
  //       state.copyWith(
  //         status: UserProfileStatus.success,
  //         toggleBlockUnblockData: data,
  //       ),
  //     );
  //   } catch (error) {
  //     emit(
  //       state.copyWith(
  //         status: UserProfileStatus.failure,
  //         errorMessage: ErrorHandler.handle(error),
  //       ),
  //     );
  //   }
  // }
  Future<void> _onFetchPostsByUsername(
    FetchPostsByUsername event,
    Emitter<UserProfileState> emit,
  ) async {
    try {
      final data = await fetchPostsByUsernameUsecase(event.username);
      emit(state.copyWith(userPosts: data['posts'] ?? []));
    } catch (error) {
      emit(state.copyWith(errorMessage: ErrorHandler.handle(error)));
    }
  }
}
