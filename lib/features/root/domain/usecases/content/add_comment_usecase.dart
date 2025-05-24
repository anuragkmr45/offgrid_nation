import 'package:offgrid_nation_app/features/root/domain/entities/comment_model.dart';
import 'package:offgrid_nation_app/features/root/domain/repositories/content_repository.dart';

class AddCommentUsecase {
  final ContentRepository repository;

  AddCommentUsecase(this.repository);

  Future<CommentModel> call({required String postId, required String content}) {
    return repository.addComment(postId, content);
  }
}
