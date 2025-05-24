import 'package:offgrid_nation_app/features/root/domain/repositories/content_repository.dart';

class ToggleCommentLikeUsecase {
  final ContentRepository repository;

  ToggleCommentLikeUsecase(this.repository);

  Future<void> call(String commentId) {
    return repository.toggleCommentLike(commentId);
  }
}
