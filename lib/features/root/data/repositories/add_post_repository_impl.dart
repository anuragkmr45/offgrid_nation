import 'dart:io';
import 'package:offgrid_nation_app/features/root/domain/repositories/add_post_repository.dart';
import 'package:offgrid_nation_app/features/root/data/datasources/add_post_remote_data_source.dart';

class AddPostRepositoryImpl implements AddPostRepository {
  final AddPostRemoteDataSource remoteDataSource;

  AddPostRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> addPost({
    required String content,
    String? location,
    List<File>? mediaFiles,
  }) {
    return remoteDataSource.createPost(
      content: content,
      location: location,
      mediaFiles: mediaFiles,
    );
  }
}
