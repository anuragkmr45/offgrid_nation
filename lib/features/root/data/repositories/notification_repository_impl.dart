import '../../domain/entities/notification_entity.dart';
import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_datasource.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource remote;

  NotificationRepositoryImpl(this.remote);

  @override
  Future<List<NotificationEntity>> fetchNotifications(int page, int limit) =>
      remote.fetchNotifications(page: page, limit: limit);

  @override
  Future<void> markAsRead(List<String> ids) => remote.markAsRead(ids);
}