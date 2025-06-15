import 'package:equatable/equatable.dart';

class ChatUserEntity extends Equatable {
  final String id;
  final String username;
  final String fullName;
  final String profilePicture;
  final String? conversationId;

  const ChatUserEntity({
    required this.id,
    required this.username,
    required this.fullName,
    required this.profilePicture,
    this.conversationId,
  });

  factory ChatUserEntity.fromJson(Map<String, dynamic> json) {
    return ChatUserEntity(
      id: json['_id'],
      username: json['username'],
      fullName: json['fullName'],
      profilePicture: json['profilePicture'],
      conversationId: json['conversationId'],
    );
  }

  factory ChatUserEntity.fallback() => const ChatUserEntity(
    id: '',
    username: '',
    fullName: '',
    profilePicture: '',
    conversationId: '',
  );

  @override
  List<Object?> get props => [id, username, fullName, profilePicture, conversationId];
}
