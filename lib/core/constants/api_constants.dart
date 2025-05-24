class ApiConstants {
  static const String baseUrl = "https://api.theoffgridnation.com";

  // auth endpoints
  static const String signInEndpoint = "/auth/login";
  static const String signUpEndpoint = "/auth/register/complete";
  static const String socialLoginEndpoint = "/auth/social-login";
  static const String sendotp = "/auth/register/send-otp";
  static const String verifyotp = "/auth/register/verify-otp";
  static const String usernameValidationEndpoint = "/auth/check-username";
  static const String forgotPasswordEndpoint = "/auth/forgot-password";
  static const String verifyPhoneResetPasswordEndpoint =
      "/auth/verify-forgot-password-otp";
  static const String resetPasswordEndpoint = "/auth/reset-password";

  // user endpoints
  static const String getProfileEndpoint = "/user/profile";
  static const String viewUserEndpoint = "/user/:username";
  static const String updateProfileEndpoint = "/user/profile";
  static const String updateProfilePhotoEndpoint =
      "/user/profile/upload-picture";

  // lists endpoints
  static const String getFollowersEndpoint = "/user/:username/followers";
  static const String getFollowingEndpoint = "/user/:username/following";
  static const String getBlockedUsersEndpoint = "/user/blocked";
  static const String getFollowRequestEndpoint = "/user/follow-requests";
  static const String getSearchResultEndpoint = "/user/search";
  static const String getUserPostsEndpoint = "/post/:username";

  // social interactions endpoints
  static const String updateToggleFollowUnfollowEndpoint =
      "/user/follow/:username";
  static const String updateToggleBlockUnblockEndpoint =
      "/user/block/:username";
  static const String updateAcceptFollowRequestEndpoint =
      "/user/accept-follow-request";

  // privacy settings endpoints
  static const String updateProfilePrivacyEndpoint = "/user/privacy-settings";

  // content endpoints
  static const String fetchfeedEndpoint = "/feed";
  static const String toggleLikeDislikeEndpoint = "/post/postId/like";
  static const String fetchCommentsEndpoint = "/comment/:postId";
  static const String addCommentEndpoint = "/comment/:postId";
  static const String toggleCommentLikeEndpoint = "/comment/:commentId/like";
  static const String addReplyEndpoint = "/comment/:commentId/reply";
  static const String fetchRepliesEndpoint = "/comment/reply/:commentId";

  static const String addPostEndpoint = "/post";

  // Marketplace endpoints
  static const String addProductEndpoint = "/products";
  static const String getProductDetailsEndpoint = "/products/:productId";
  static const String listProductsEndpoint = "/products";
  static const String addRatingEndpoint = "/ratings/:productId";
  static const String getRatingsEndpoint = "/ratings/:productId";
  static const String listCategoriesEndpoint = "/categories";
  static const String listMyProductsEndpoint = "/products/me/my-products";
  static const String searchProductsEndpoint = "/products/search";
static const String deleteProductEndpoint = "/products/:productId";

  // Notifications
  static const String getNotificationsEndpoint = "/notifications";
  static const String markNotificationsReadEndpoint =
      "/notifications/mark-read";
}
