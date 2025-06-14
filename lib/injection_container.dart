import 'package:get_it/get_it.dart';
import 'package:firebase_auth/firebase_auth.dart' show FirebaseAuth;
import 'package:google_sign_in/google_sign_in.dart' show GoogleSignIn;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:offgrid_nation_app/core/network/api_client.dart';
import 'package:offgrid_nation_app/core/constants/api_constants.dart';
import 'package:offgrid_nation_app/core/session/auth_session.dart';
// import 'package:offgrid_nation_app/core/session/social_auth_session.dart';

// auth
import 'package:offgrid_nation_app/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:offgrid_nation_app/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:offgrid_nation_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:offgrid_nation_app/features/auth/domain/usecases/check_username_availability_usecase.dart';
import 'package:offgrid_nation_app/features/auth/domain/usecases/login_usecase.dart';
import 'package:offgrid_nation_app/features/auth/domain/usecases/reset_password_usecase.dart';
import 'package:offgrid_nation_app/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:offgrid_nation_app/features/auth/domain/usecases/signup_usecase.dart';
import 'package:offgrid_nation_app/features/auth/domain/usecases/verify_otp_usecase.dart';
import 'package:offgrid_nation_app/features/auth/domain/usecases/send_otp_usecase.dart';
import 'package:offgrid_nation_app/features/auth/presentation/bloc/login_bloc.dart';
import 'package:offgrid_nation_app/features/auth/presentation/bloc/reset_password_bloc.dart';
import 'package:offgrid_nation_app/features/auth/presentation/bloc/signup_bloc.dart';
import 'package:offgrid_nation_app/features/chat/data/datasource/chat_remote_datasource.dart';
import 'package:offgrid_nation_app/features/chat/data/repositories/chat_repository_impl.dart';
import 'package:offgrid_nation_app/features/chat/domain/repositories/chat_repository.dart';
import 'package:offgrid_nation_app/features/chat/domain/usecases/delete_conversation_usecase.dart';
import 'package:offgrid_nation_app/features/chat/domain/usecases/get_conversations_usecase.dart';
import 'package:offgrid_nation_app/features/chat/domain/usecases/get_messages_by_recipient_usecase.dart';
import 'package:offgrid_nation_app/features/chat/domain/usecases/get_messages_usecase.dart';
import 'package:offgrid_nation_app/features/chat/domain/usecases/mark_conversation_read_usecase.dart';
import 'package:offgrid_nation_app/features/chat/domain/usecases/mute_conversation_usecase.dart';
import 'package:offgrid_nation_app/features/chat/domain/usecases/search_users_usecase.dart';
import 'package:offgrid_nation_app/features/chat/domain/usecases/send_message_usecase.dart';
import 'package:offgrid_nation_app/features/chat/domain/usecases/upload_media_usecase.dart';
import 'package:offgrid_nation_app/features/chat/presentation/bloc/chat_bloc.dart';
import 'package:offgrid_nation_app/features/marketplace/data/datasources/marketplace_remote_datasource.dart';
import 'package:offgrid_nation_app/features/marketplace/data/repositories/marketplace_repository_impl.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/repositories/marketplace_repository.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/add_product_usecase.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/add_rating_usecase.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/delete_product_usecase.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/get_categories_usecase.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/get_product_details_usecase.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/get_ratings_usecase.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/list_products_usecase.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/my_product_list_usercase.dart';
import 'package:offgrid_nation_app/features/marketplace/domain/usecases/search_products_usecase.dart';
import 'package:offgrid_nation_app/features/marketplace/presentation/bloc/marketplace_bloc.dart';
import 'package:offgrid_nation_app/features/root/data/datasources/add_post_remote_data_source.dart';
import 'package:offgrid_nation_app/features/root/data/datasources/content_remote_data_source.dart';
import 'package:offgrid_nation_app/features/root/data/datasources/notification_remote_datasource.dart';
import 'package:offgrid_nation_app/features/root/data/datasources/premium_remote_data_source.dart';

// profile
import 'package:offgrid_nation_app/features/root/data/datasources/user_profile_remote_data_source.dart';
import 'package:offgrid_nation_app/features/root/data/repositories/add_post_repository_impl.dart';
import 'package:offgrid_nation_app/features/root/data/repositories/content_repository_impl.dart';
import 'package:offgrid_nation_app/features/root/data/repositories/notification_repository_impl.dart';
import 'package:offgrid_nation_app/features/root/data/repositories/premium_repository_impl.dart';
import 'package:offgrid_nation_app/features/root/data/repositories/user_profile_repository_impl.dart';
import 'package:offgrid_nation_app/features/root/domain/repositories/add_post_repository.dart';
import 'package:offgrid_nation_app/features/root/domain/repositories/content_repository.dart';
import 'package:offgrid_nation_app/features/root/domain/repositories/notification_repository.dart';
import 'package:offgrid_nation_app/features/root/domain/repositories/premium_repository.dart';
import 'package:offgrid_nation_app/features/root/domain/repositories/user_profile_repository.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/content/add_comment_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/content/add_reply_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/content/content_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/content/fetch_comments_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/content/fetch_replies_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/content/send_post_message_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/content/toggle_comment_like_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/content/toggle_like_dislike_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/notification/fetch_notifications_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/notification/mark_notifications_read_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/posts/add_post_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/premium/create_checkout_session_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/fetch_blocked_users_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/fetch_follower_requests_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/fetch_followers_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/fetch_following_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/fetch_posts_by_username_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/fetch_profile_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/fetch_user_profile_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/update_accept_follow_request_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/update_profile_photo_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/update_profile_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/update_toggle_block_unblock_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/user_profile/update_toggle_follow_unfollow_usecase.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/add_post_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/content_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/notification_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/premium_bloc.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/user_profile_bloc.dart';

// search
import 'package:offgrid_nation_app/features/root/data/datasources/search_remote_data_source.dart';
import 'package:offgrid_nation_app/features/root/data/repositories/search_repository_impl.dart';
import 'package:offgrid_nation_app/features/root/domain/repositories/search_repository.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/search/search_users_usecase.dart';
import 'package:offgrid_nation_app/features/root/presentation/bloc/search_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // ─────────────────────────────────────────────────────────────────
  // Core Dependencies
  // ─────────────────────────────────────────────────────────────────
  // Secure storage
  sl.registerLazySingleton<FlutterSecureStorage>(
    () => const FlutterSecureStorage(),
  );
  // API client
  sl.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: ApiConstants.baseUrl),
  );
  // Firebase & Google Sign-In
  sl.registerLazySingleton(() => FirebaseAuth.instance);
  sl.registerLazySingleton<GoogleSignIn>(
    () => GoogleSignIn(scopes: ['email', 'profile', 'openid']),
  );
  // Auth session
  // sl.registerLazySingleton<AuthSession>(() => AuthSession());
  // Auth session (injecting ApiClient)
  sl.registerLazySingleton<AuthSession>(
    () => AuthSession(apiClient: sl<ApiClient>()),
  );

  // sl.registerLazySingleton<SocialAuthSession>(() => SocialAuthSession());

  // ─────────────────────────────────────────────────────────────────────────────
  // ✅ Auth Feature
  // ─────────────────────────────────────────────────────────────────────────────
  // Remote data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(apiClient: sl<ApiClient>()),
  );

  // Repositories
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl<AuthRemoteDataSource>(),
      secureStorage: sl<FlutterSecureStorage>(),
    ),
  );
  // Use-Cases
  sl.registerLazySingleton(() => LoginUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => SignupUseCase(sl<AuthRepository>()));
  sl.registerLazySingleton(() => CheckUsernameAvailabilityUseCase(sl()));
  sl.registerLazySingleton(() => VerifyOTPUseCase(sl()));
  sl.registerLazySingleton(() => SendOTPUseCase(sl()));
  sl.registerLazySingleton(() => ResetPasswordUseCase(sl()));

  sl.registerLazySingleton(
    () => SignInWithGoogleUseCase(
      repository: sl<AuthRepository>(),
      firebaseAuth: sl<FirebaseAuth>(),
      googleSignIn: sl<GoogleSignIn>(),
    ),
  );

  sl.registerFactory(
    () => LoginBloc(loginUseCase: sl(), signInWithGoogleUseCase: sl()),
  );

  sl.registerFactory(
    () => SignupBloc(
      signupUseCase: sl(),
      checkUsernameAvailabilityUseCase: sl(),
      verifyOTPUseCase: sl(),
      sendOTPUseCase: sl(),
    ),
  );

  sl.registerFactory(() => ResetPasswordBloc(sl<ResetPasswordUseCase>()));

  // ─────────────────────────────────────────────────────────────────
  // User Profile Feature
  // ─────────────────────────────────────────────────────────────────
  // Data Source
  sl.registerLazySingleton<UserProfileRemoteDataSource>(
    () => UserProfileRemoteDataSourceImpl(
      apiClient: sl<ApiClient>(),
      authSession: sl<AuthSession>(),
    ),
  );
  // Repository
  sl.registerLazySingleton<UserProfileRepository>(
    () => UserProfileRepositoryImpl(sl<UserProfileRemoteDataSource>()),
  );
  // Use-Cases
  sl.registerLazySingleton(() => FetchProfileUsecase(sl()));
  sl.registerLazySingleton(() => FetchUserProfileUsecase(sl()));
  sl.registerLazySingleton(() => UpdateProfileUsecase(sl()));
  sl.registerLazySingleton(() => UpdateProfilePhotoUsecase(sl()));
  sl.registerLazySingleton(() => FetchFollowersUsecase(sl()));
  sl.registerLazySingleton(() => FetchFollowingUsecase(sl()));
  sl.registerLazySingleton(() => FetchFollowerRequestsUsecase(sl()));
  sl.registerLazySingleton(() => FetchBlockedUsersUsecase(sl()));
  sl.registerLazySingleton(() => UpdateAcceptFollowRequestUsecase(sl()));
  sl.registerLazySingleton(
    () => UpdateToggleFollowUnfollowUsecase(sl<UserProfileRepository>()),
  );
  sl.registerLazySingleton(
    () => UpdateToggleBlockUnblockUsecase(sl<UserProfileRepository>()),
  );
  // BLoC
  sl.registerFactory(
    () => UserProfileBloc(
      fetchProfileUsecase: sl(),
      fetchUserProfileUsecase: sl(),
      updateProfileUsecase: sl(),
      updateProfilePhotoUsecase: sl(),
      fetchFollowersUsecase: sl(),
      fetchFollowingUsecase: sl(),
      fetchFollowerRequestsUsecase: sl(),
      fetchBlockedUsersUsecase: sl(),
      updateAcceptFollowRequestUsecase: sl(),
      // updateToggleBlockUnblockUsecase: sl(),
      updateToggleFollowUnfollowUsecase: sl(),
      fetchPostsByUsernameUsecase: sl(),
    ),
  );
  sl.registerLazySingleton(() => FetchPostsByUsernameUsecase(sl()));

  // ─────────────────────────────────────────────────────────────────
  // Search Feature
  // ─────────────────────────────────────────────────────────────────
  // Data Source
  // sl.registerLazySingleton<SearchUserRemoteDataSource>(
  //   () => SearchUserRemoteDataSourceImpl(
  //     apiClient: sl<ApiClient>(),
  //     authSession: sl<AuthSession>(),
  //   ),
  // );
  // // Repository
  // sl.registerLazySingleton<SearchUserRepository>(
  //   () => SearchUserRepositoryImpl(sl<SearchUserRemoteDataSource>()),
  // );
  // // Use-Case
  // sl.registerLazySingleton(
  //   () => FetchSearchUsersUsecase(sl<SearchUserRepository>()),
  // );
  // // BLoC
  // sl.registerFactory(
  //   () =>
  //       SearchUserBloc(fetchSearchUsersUsecase: sl<FetchSearchUsersUsecase>()),
  // );
  sl.registerLazySingleton<SearchUserRemoteDataSource>(
    () => SearchUserRemoteDataSourceImpl(
      apiClient: sl<ApiClient>(),
      authSession: sl<AuthSession>(),
    ),
  );

  sl.registerLazySingleton<SearchUserRepository>(
    () => SearchUserRepositoryImpl(sl<SearchUserRemoteDataSource>()),
  );

  sl.registerLazySingleton(() => FetchSearchUsersUsecase(sl()));

  sl.registerFactory(() => SearchUserBloc(fetchSearchUsersUsecase: sl()));

  // ─────────────────────────────────────────────────────────────────
  // feed
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ContentRemoteDataSource>(
    () => ContentRemoteDataSourceImpl(apiClient: sl(), authSession: sl()),
  );

  sl.registerLazySingleton<ContentRepository>(
    () => ContentRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => FetchContentUsecase(sl()));

  // Use Cases
  sl.registerLazySingleton(() => ToggleLikeDislikeUsecase(sl()));
  sl.registerLazySingleton(() => FetchCommentsUsecase(sl()));
  sl.registerLazySingleton(() => AddCommentUsecase(sl()));
  sl.registerLazySingleton(() => ToggleCommentLikeUsecase(sl()));
  sl.registerLazySingleton(() => FetchRepliesUsecase(sl()));
  sl.registerLazySingleton(() => AddReplyUsecase(sl()));

  sl.registerFactory(
    () => ContentBloc(
      fetchUsecase: sl(),
      toggleLikeDislikeUsecase: sl(),
      authSession: sl(),
      fetchCommentsUsecase: sl(),
      addCommentUsecase: sl(),
      toggleCommentLikeUsecase: sl(),
      fetchRepliesUsecase: sl(),
      addReplyUsecase: sl(),
    ),
  );

  // ─────────────────────────────────────────────────────────────────
  // add post
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<AddPostRemoteDataSource>(
    () => AddPostRemoteDataSource(authSession: sl<AuthSession>()),
  );

  sl.registerLazySingleton<AddPostRepository>(
    () =>
        AddPostRepositoryImpl(remoteDataSource: sl<AddPostRemoteDataSource>()),
  );
  sl.registerLazySingleton(() => AddPostUseCase(repository: sl()));
  sl.registerFactory(() => AddPostBloc(addPostUseCase: sl()));

  // ─────────────────────────────────────────────────────────────────
  // marketplace
  // ─────────────────────────────────────────────────────────────────
  // Data source
  sl.registerLazySingleton<MarketplaceRemoteDataSource>(
    () => MarketplaceRemoteDataSourceImpl(apiClient: sl(), authSession: sl()),
  );

  // Repository
  sl.registerLazySingleton<MarketplaceRepository>(
    () => MarketplaceRepositoryImpl(remoteDataSource: sl()),
  );

  // Use cases
  sl.registerLazySingleton(() => AddProductUseCase(sl()));
  sl.registerLazySingleton(() => GetProductDetailsUseCase(sl()));
  sl.registerLazySingleton(() => ListProductsUseCase(sl()));
  sl.registerLazySingleton(() => AddRatingUseCase(sl()));
  sl.registerLazySingleton(() => GetRatingsUseCase(sl()));
  sl.registerLazySingleton(() => GetCategoriesUseCase(sl()));
  sl.registerLazySingleton(() => MyProductListUseCase(sl()));
  sl.registerLazySingleton(() => DeleteProductUseCase(sl()));
  sl.registerLazySingleton(() => SearchProductsUseCase(sl()));

  // Bloc
  sl.registerFactory(
    () => MarketplaceBloc(
      addProductUseCase: sl(),
      getProductDetailsUseCase: sl(),
      listProductsUseCase: sl(),
      // addRatingUseCase: sl(),
      // getRatingsUseCase: sl(),
      getCategoriesUseCase: sl(),
      myProductListUseCase: sl(),
      deleteProductUseCase: sl(),
      searchProductsUseCase: sl(),
    ),
  );

  // ─────────────────────────────────────────────────────────────────
  // notifications
  // ─────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(
      apiClient: sl<ApiClient>(),
      authSession: sl<AuthSession>(),
    ),
  );

  sl.registerLazySingleton<NotificationRepository>(
    () => NotificationRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => FetchNotificationsUseCase(sl()));
  sl.registerLazySingleton(() => MarkNotificationsReadUseCase(sl()));
  sl.registerFactory(
    () =>
        NotificationBloc(fetchNotifications: sl(), markNotificationsRead: sl()),
  );

  // ─────────────────────────────────────────────────────────────────────────────
  // 💬 Chat Module
  // ─────────────────────────────────────────────────────────────────────────────
  sl.registerLazySingleton<ChatRemoteDataSource>(
    () => ChatRemoteDataSourceImpl(apiClient: sl(), authSession: sl()),
  );

  sl.registerLazySingleton<ChatRepository>(
    () => ChatRepositoryImpl(remoteDataSource: sl()),
  );

  sl.registerLazySingleton(() => SendMessageUsecase(sl()));
  sl.registerLazySingleton(() => GetMessagesUsecase(sl()));
  sl.registerLazySingleton(() => UploadMediaUsecase(sl()));
  sl.registerLazySingleton(() => GetConversationsUsecase(sl()));
  sl.registerLazySingleton(() => MarkConversationReadUsecase(sl()));
  sl.registerLazySingleton(() => MuteConversationUsecase(sl()));
  sl.registerLazySingleton(() => DeleteConversationUsecase(sl()));
  sl.registerLazySingleton(() => SearchUsersUsecase(sl()));
  sl.registerLazySingleton<GetMessagesByRecipientUsecase>(
    () => GetMessagesByRecipientUsecase(sl()),
  );
  sl.registerLazySingleton(() => SendPostMessageUsecase(sl()));

  sl.registerFactory(
    () => ChatBloc(
      sendMessageUsecase: sl(),
      getMessagesUsecase: sl(),
      uploadMediaUsecase: sl(),
      getConversationsUsecase: sl(),
      markReadUsecase: sl(),
      muteUsecase: sl(),
      deleteUsecase: sl(),
      searchUsersUsecase: sl(),
      getMessagesByRecipientUsecase: sl(),
      sendPostMessageUsecase: sl(),
    ),
  );

  // Premium Feature
  sl.registerLazySingleton<PremiumRemoteDataSource>(
    () => PremiumRemoteDataSourceImpl(apiClient: sl(), authSession: sl()),
  );

  sl.registerLazySingleton<PremiumRepository>(
    () => PremiumRepositoryImpl(sl()),
  );

  sl.registerLazySingleton(() => CreateCheckoutSessionUseCase(sl()));

  sl.registerFactory(() => PremiumBloc(createCheckoutSessionUseCase: sl()));
}
