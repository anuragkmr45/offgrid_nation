import 'package:equatable/equatable.dart';
import './chat_user_entity.dart';
import './message_entity.dart';

class ConversationEntity extends Equatable {
  final String conversationId;
  final ChatUserEntity user;
  final MessageEntity lastMessage;
  final DateTime updatedAt;
  final bool muted;
  final int unreadCount;

  const ConversationEntity({
    required this.conversationId,
    required this.user,
    required this.lastMessage,
    required this.updatedAt,
    required this.muted,
    required this.unreadCount,
  });

factory ConversationEntity.fromJson(Map<String, dynamic> json) {
  return ConversationEntity(
    conversationId: json['conversationId'] ?? '',
    user: json['user'] != null
        ? ChatUserEntity.fromJson(json['user'])
        : ChatUserEntity.fallback(),
    lastMessage: json['lastMessage'] != null
        ? MessageEntity.fromJson(json['lastMessage'])
        : MessageEntity.fallback(),
    updatedAt: json['updatedAt'] != null
        ? DateTime.tryParse(json['updatedAt']) ?? DateTime.now()
        : DateTime.now(),
    muted: json['muted'] ?? false,
    unreadCount: json['unreadCount'] ?? 0,
  );
}


  @override
  List<Object?> get props => [
    conversationId,
    user,
    lastMessage,
    updatedAt,
    muted,
    unreadCount,
  ];
}
