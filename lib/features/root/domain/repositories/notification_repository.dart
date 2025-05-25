import '../entities/notification_entity.dart';

abstract class NotificationRepository {
  Future<List<NotificationEntity>> fetchNotifications(int page, int limit);
  Future<void> markAsRead(List<String> ids);
}
