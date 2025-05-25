import '../../entities/notification_entity.dart';
import '../../repositories/notification_repository.dart';

class FetchNotificationsUseCase {
  final NotificationRepository repository;

  FetchNotificationsUseCase(this.repository);

  Future<List<NotificationEntity>> call({int page = 1, int limit = 20}) async {
    return repository.fetchNotifications(page, limit);
  }
}