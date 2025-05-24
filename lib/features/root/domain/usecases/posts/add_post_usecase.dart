import 'dart:io';
import 'package:offgrid_nation_app/features/root/domain/repositories/add_post_repository.dart';

class AddPostUseCase {
  final AddPostRepository repository;

  AddPostUseCase({required this.repository});

  Future<Map<String, dynamic>> call({
    required String content,
    String? location,
    List<File>? mediaFiles,
  }) {
    return repository.addPost(
      content: content,
      location: location,
      mediaFiles: mediaFiles,
    );
  }
}
