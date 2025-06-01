import 'package:equatable/equatable.dart';

class AttachmentEntity extends Equatable {
  final String type; // e.g., "image", "video"
  final String url;

  const AttachmentEntity({
    required this.type,
    required this.url,
  });

  factory AttachmentEntity.fromJson(Map<String, dynamic> json) {
    return AttachmentEntity(
      type: json['type'] ?? '',
      url: json['url'] ?? '',
    );
  }

  @override
  List<Object?> get props => [type, url];
}
