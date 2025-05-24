// lib/features/root/domain/usecases/content/toggle_like_dislike_usecase.dart
import '../../repositories/content_repository.dart';

class ToggleLikeDislikeUsecase {
  final ContentRepository repository;

  ToggleLikeDislikeUsecase(this.repository);

  Future<Map<String, dynamic>> call(String postId) {
    return repository.toggleLikeDislike(postId);
  }
}
