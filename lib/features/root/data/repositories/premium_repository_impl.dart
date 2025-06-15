import 'package:offgrid_nation_app/core/errors/network_exception.dart';
import 'package:offgrid_nation_app/features/root/data/datasources/premium_remote_data_source.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/premium/post_entity.dart';
import 'package:offgrid_nation_app/features/root/domain/repositories/premium_repository.dart';

class PremiumRepositoryImpl implements PremiumRepository {
  final PremiumRemoteDataSource remoteDataSource;

  PremiumRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> createCheckoutSession() {
    return remoteDataSource.createCheckoutSession();
  }

  @override
  Future<List<PostEntity>> fetchPremiumFeed() async {
    final response = await remoteDataSource.fetchPremiumFeed();
    if (!response.isPremium) {
      throw NetworkException("USER_NOT_PREMIUM");
    }
    return response.posts;
  }
}
