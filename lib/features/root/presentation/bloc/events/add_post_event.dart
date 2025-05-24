import 'dart:io';

abstract class AddPostEvent {}

class SubmitPostEvent extends AddPostEvent {
  final String content;
  final String? location;
  final List<File>? mediaFiles;

  SubmitPostEvent({required this.content, this.location, this.mediaFiles});
}
