class ChatApiConstants {
  static const String baseUrl = 'https://api.theoffgridnation.com';

  // Media Uploads
  static const String uploadImage = '/media/image';
  static const String uploadVideo = '/media/video';
  static const String uploadAudio = '/media/audio';

  // Conversations
  static const String getConversations = '/conversations';
  static String searchUsers(String query) => '/conversations/search?q=$query';
  static String getMessages(String conversationId, {String? cursor}) =>
      '/conversations/$conversationId/messages${cursor != null ? '?cursor=$cursor' : ''}';
  static String markConversationRead(String conversationId) =>
      '/conversations/$conversationId/read';
  static String muteConversation(String conversationId) =>
      '/conversations/$conversationId/mute';
  static String deleteConversation(String conversationId) =>
      '/conversations/$conversationId';

  // Messaging
  static const String sendMessage = '/messages';

  // Real-Time Channels (for reference only, not API calls)
  static String directChannel(String conversationId) =>
      'direct.$conversationId';
  static String notificationChannel(String userId) => 'notifications.$userId';
}
