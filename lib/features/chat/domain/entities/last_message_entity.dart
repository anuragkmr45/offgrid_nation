import 'package:equatable/equatable.dart';
import 'package:offgrid_nation_app/features/chat/domain/entities/attachment_entity.dart';
import 'package:offgrid_nation_app/features/chat/domain/entities/message_entity.dart';

class LastMessageEntity extends Equatable {
  final String? text;
  final List<AttachmentEntity> attachments;
  final String senderId;
  final DateTime sentAt;
  final String status;
  final String actionType;

  const LastMessageEntity({
    this.text,
    required this.attachments,
    required this.senderId,
    required this.sentAt,
    required this.status,
    required this.actionType,
  });

  factory LastMessageEntity.fromJson(Map<String, dynamic> json) {
    return LastMessageEntity(
      text: json['text'],
      attachments: MessageEntity.parseAttachments(json['attachments']),
      senderId: json['sender'] ?? '',
      sentAt: DateTime.parse(json['sentAt']),
      status: json['status'] ?? 'sent',
      actionType: json['actionType'] ?? 'text',
    );
  }

  @override
  List<Object?> get props => [text, attachments, senderId, sentAt, status, actionType];
}
