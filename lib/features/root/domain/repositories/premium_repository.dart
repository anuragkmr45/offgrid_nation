import 'package:offgrid_nation_app/features/root/domain/entities/premium/post_entity.dart';

abstract class PremiumRepository {
  Future<String> createCheckoutSession();
  Future<List<PostEntity>> fetchPremiumFeed();
}
