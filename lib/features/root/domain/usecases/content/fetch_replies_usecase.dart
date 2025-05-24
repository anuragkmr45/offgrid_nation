import 'package:offgrid_nation_app/features/root/domain/entities/reply_model.dart';
import 'package:offgrid_nation_app/features/root/domain/repositories/content_repository.dart';

class FetchRepliesUsecase {
  final ContentRepository repository;

  FetchRepliesUsecase(this.repository);

  Future<List<ReplyModel>> call({
    required String commentId,
    int limit = 20,
    String? cursor,
  }) {
    return repository.fetchReplies(commentId, limit: limit, cursor: cursor);
  }
}
