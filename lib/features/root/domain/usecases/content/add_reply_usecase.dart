import 'package:offgrid_nation_app/features/root/domain/entities/reply_model.dart';
import 'package:offgrid_nation_app/features/root/domain/repositories/content_repository.dart';

class AddReplyUsecase {
  final ContentRepository repository;

  AddReplyUsecase(this.repository);

  Future<ReplyModel> call({
    required String commentId,
    required String content,
  }) {
    return repository.addReply(commentId, content);
  }
}
