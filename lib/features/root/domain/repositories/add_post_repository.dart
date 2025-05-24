import 'dart:io';

abstract class AddPostRepository {
  Future<Map<String, dynamic>> addPost({
    required String content,
    String? location,
    List<File>? mediaFiles,
  });
}
