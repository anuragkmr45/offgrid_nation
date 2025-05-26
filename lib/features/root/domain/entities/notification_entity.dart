// 📁 lib/features/notification/domain/entities/notification_entity.dart

import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String type;
  final String? fromUserId;
  final String? toUserId;
  final String? postId;
  final String? commentId;
  final String? replyId;
  final String? message;
  final String? senderUsername;
  final String? profilePicture;
  final bool read;
  final DateTime createdAt;

  const NotificationEntity({
    required this.id,
    required this.type,
    required this.fromUserId,
    required this.toUserId,
    this.postId,
    this.commentId,
    this.replyId,
    this.message,
    this.senderUsername,
    this.profilePicture,
    required this.read,
    required this.createdAt,
  });

  @override
  List<Object?> get props => [
    id, type, fromUserId, toUserId, postId, commentId, replyId,
    message, senderUsername, profilePicture, read, createdAt
  ];
}
