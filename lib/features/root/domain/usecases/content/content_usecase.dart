import 'package:offgrid_nation_app/features/root/domain/entities/content_modal.dart';
import 'package:offgrid_nation_app/features/root/domain/repositories/content_repository.dart';

class FetchContentUsecase {
  final ContentRepository repository;

  FetchContentUsecase(this.repository);

  Future<(List<ContentModel>, String?)> call({int limit = 20, String? cursor}) {
    return repository.getFeed(limit: limit, cursor: cursor);
  }
}
