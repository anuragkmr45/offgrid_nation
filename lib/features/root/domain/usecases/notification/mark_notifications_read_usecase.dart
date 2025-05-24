import '../../repositories/notification_repository.dart';

class MarkNotificationsReadUseCase {
  final NotificationRepository repository;

  MarkNotificationsReadUseCase(this.repository);

  Future<void> call(List<String> ids) async {
    return repository.markAsRead(ids);
  }
}