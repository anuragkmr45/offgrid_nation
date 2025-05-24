import 'package:equatable/equatable.dart';

abstract class NotificationEvent extends Equatable {
  const NotificationEvent();

  @override
  List<Object?> get props => [];
}

class FetchNotificationsRequested extends NotificationEvent {
  final int page;
  final int limit;

  const FetchNotificationsRequested({this.page = 1, this.limit = 20});

  @override
  List<Object?> get props => [page, limit];
}

class MarkNotificationsReadRequested extends NotificationEvent {
  final List<String> ids;

  const MarkNotificationsReadRequested(this.ids);

  @override
  List<Object?> get props => [ids];
}