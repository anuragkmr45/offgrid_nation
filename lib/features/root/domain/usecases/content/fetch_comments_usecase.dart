import 'package:offgrid_nation_app/features/root/domain/entities/comment_model.dart';
import 'package:offgrid_nation_app/features/root/domain/repositories/content_repository.dart';

class FetchCommentsUsecase {
  final ContentRepository repository;

  FetchCommentsUsecase(this.repository);

  Future<List<CommentModel>> call({
    required String postId,
    int limit = 20,
    String? cursor,
  }) {
    return repository.fetchComments(postId, limit: limit, cursor: cursor);
  }
}
