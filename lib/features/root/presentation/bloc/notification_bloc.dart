import 'package:flutter_bloc/flutter_bloc.dart';
import './events/notification_event.dart';
import './states/notification_state.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/notification/mark_notifications_read_usecase.dart';
import 'package:offgrid_nation_app/features/root/domain/usecases/notification/fetch_notifications_usecase.dart';

class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final FetchNotificationsUseCase fetchNotifications;
  final MarkNotificationsReadUseCase markNotificationsRead;

  NotificationBloc({
    required this.fetchNotifications,
    required this.markNotificationsRead,
  }) : super(NotificationInitial()) {
    on<FetchNotificationsRequested>((event, emit) async {
      emit(NotificationLoading());
      try {
        final notifications = await fetchNotifications(page: event.page, limit: event.limit);
        emit(NotificationLoaded(notifications));
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });

    on<MarkNotificationsReadRequested>((event, emit) async {
      try {
        await markNotificationsRead(event.ids);
        emit(NotificationMarkedAsRead());
      } catch (e) {
        emit(NotificationError(e.toString()));
      }
    });
  }
}