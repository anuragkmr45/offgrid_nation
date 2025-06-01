import 'package:equatable/equatable.dart';
import 'chat_user_entity.dart';
import 'post_payload_entity.dart';
import 'attachment_entity.dart';

class MessageEntity extends Equatable {
  final String id;
  final String conversationId;
  final ChatUserEntity sender;
  final ChatUserEntity recipient;
  final String? text;
  final List<AttachmentEntity> attachments;
  final DateTime sentAt;
  final DateTime? deliveredAt;
  final DateTime? readAt;
  final String actionType;
  final PostPayloadEntity? postPayload;

  const MessageEntity({
    required this.id,
    required this.conversationId,
    required this.sender,
    required this.recipient,
    this.text,
    required this.attachments,
    required this.sentAt,
    this.deliveredAt,
    this.readAt,
    required this.actionType,
    this.postPayload,
  });

  factory MessageEntity.fromJson(Map<String, dynamic> json) {
    return MessageEntity(
      id: json['_id'] ?? '',
      conversationId: json['conversationId'] ?? '',
      sender: _parseUser(json['sender']),
      recipient: _parseUser(json['recipient']),
      text: json['text'],
      attachments: _parseAttachments(json['attachments']),
      sentAt: DateTime.parse(json['sentAt']),
      deliveredAt: json['deliveredAt'] != null
          ? DateTime.tryParse(json['deliveredAt'])
          : null,
      readAt: json['readAt'] != null
          ? DateTime.tryParse(json['readAt'])
          : null,
      actionType: json['actionType'] ?? 'text',
      postPayload: json['postPayload'] != null
          ? PostPayloadEntity.fromJson(json['postPayload'])
          : null,
    );
  }

  static ChatUserEntity _parseUser(dynamic raw) {
    if (raw is Map<String, dynamic>) {
      return ChatUserEntity.fromJson(raw);
    } else if (raw is String) {
      return ChatUserEntity(
        id: raw,
        username: '',
        fullName: '',
        profilePicture: '',
      );
    } else {
      return const ChatUserEntity(
        id: '',
        username: '',
        fullName: '',
        profilePicture: '',
      );
    }
  }

  static List<AttachmentEntity> _parseAttachments(dynamic raw) {
    if (raw is List) {
      return raw.map((e) {
        if (e is String) {
          return AttachmentEntity(type: 'image', url: e);
        } else if (e is Map<String, dynamic>) {
          return AttachmentEntity.fromJson(e);
        } else {
          return const AttachmentEntity(type: 'unknown', url: '');
        }
      }).toList();
    }
    return [];
  }

  @override
  List<Object?> get props => [
        id,
        conversationId,
        sender,
        recipient,
        text,
        attachments,
        sentAt,
        deliveredAt,
        readAt,
        actionType,
        postPayload,
      ];
}
