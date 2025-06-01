import 'package:equatable/equatable.dart';

class ChatUserEntity extends Equatable {
  final String id;
  final String username;
  final String fullName;
  final String profilePicture;

  const ChatUserEntity({
    required this.id,
    required this.username,
    required this.fullName,
    required this.profilePicture,
  });

  factory ChatUserEntity.fromJson(Map<String, dynamic> json) {
    return ChatUserEntity(
      id: json['_id'],
      username: json['username'],
      fullName: json['fullName'],
      profilePicture: json['profilePicture'],
    );
  }

  @override
  List<Object?> get props => [id, username, fullName, profilePicture];
}
