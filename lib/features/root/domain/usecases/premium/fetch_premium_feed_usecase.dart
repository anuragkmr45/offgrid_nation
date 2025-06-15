import 'package:offgrid_nation_app/features/root/domain/entities/premium/post_entity.dart';
import 'package:offgrid_nation_app/features/root/domain/repositories/premium_repository.dart';

class FetchPremiumFeedUseCase {
  final PremiumRepository repository;

  FetchPremiumFeedUseCase(this.repository);

  Future<List<PostEntity>> call() => repository.fetchPremiumFeed();
}
