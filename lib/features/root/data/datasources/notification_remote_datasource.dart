import 'package:offgrid_nation_app/core/constants/api_constants.dart';
import 'package:offgrid_nation_app/core/network/api_client.dart';
import '../../domain/entities/notification_entity.dart';

abstract class NotificationRemoteDataSource {
  Future<List<NotificationEntity>> fetchNotifications({int page, int limit});
  Future<void> markAsRead(List<String> ids);
}

class NotificationRemoteDataSourceImpl implements NotificationRemoteDataSource {
  final ApiClient client;

  NotificationRemoteDataSourceImpl(this.client);

  @override
  Future<List<NotificationEntity>> fetchNotifications({int page = 1, int limit = 20}) async {
    final res = await client.get(ApiConstants.getNotificationsEndpoint, queryParams: {
      'page': page.toString(),
      'limit': limit.toString(),
    });
    return (res['items'] as List).map((n) => NotificationEntity(
      id: n['_id'],
      type: n['type'],
      fromUser: n['fromUser'],
      toUser: n['toUser'],
      entityId: n['entityId'],
      meta: n['meta'],
      read: n['read'],
      createdAt: DateTime.parse(n['createdAt']),
    )).toList();
  }

  @override
  Future<void> markAsRead(List<String> ids) async {
    await client.put(ApiConstants.markNotificationsReadEndpoint, body: {"ids": ids});
  }
}