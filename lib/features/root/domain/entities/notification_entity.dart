import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String type;
  final String fromUser;
  final String toUser;
  final String entityId;
  final Map<String, dynamic>? meta;
  final bool read;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.fromUser,
    required this.toUser,
    required this.entityId,
    required this.meta,
    required this.read,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [id, type, fromUser, toUser, entityId, meta, read, createdAt];
}