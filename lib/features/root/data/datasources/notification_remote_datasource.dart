import 'package:offgrid_nation_app/core/constants/api_constants.dart';
import 'package:offgrid_nation_app/core/network/api_client.dart';
import 'package:offgrid_nation_app/core/session/auth_session.dart';
import 'package:offgrid_nation_app/core/errors/network_exception.dart';
import '../../domain/entities/notification_entity.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationEntity>> fetchNotifications({int page, int limit});
  Future<void> markAsRead(List<String> ids);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient apiClient;
  final AuthSession authSession;

  NotificationRemoteDataSourceImpl({
    required this.apiClient,
    required this.authSession,
  });

  @override
  Future<List<NotificationEntity>> fetchNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    final token = await authSession.getSessionToken();
    if (token == null) throw const NetworkException('Not authorized');

    final res = await apiClient.get(
      ApiConstants.getNotificationsEndpoint,
      headers: {'Authorization': 'Bearer $token'},
      queryParams: {'page': page.toString(), 'limit': limit.toString()},
    );

    if (res == null || res['items'] is! List) {
      throw const NetworkException('Invalid notification response');
    }

    return (res['items'] as List).map((n) => NotificationEntity(
      id: n['_id'],
      type: n['type'] ?? '',
      fromUserId: n['fromUserId'],
      toUserId: n['toUserId'],
      postId: n['postId'],
      commentId: n['commentId'],
      replyId: n['replyId'],
      message: n['message'],
      senderUsername: n['senderUsername'],
      profilePicture: n['profilePicture'],
      read: n['read'] ?? false,
      createdAt: DateTime.parse(n['createdAt']),
    )).toList();
  }

  @override
  Future<void> markAsRead(List<String> ids) async {
    final token = await authSession.getSessionToken();
    if (token == null) throw const NetworkException('Not authorized');

    await apiClient.put(
      ApiConstants.markNotificationsReadEndpoint,
      headers: {'Authorization': 'Bearer $token'},
      body: {"ids": ids},
    );
  }
}
