import 'package:offgrid_nation_app/features/root/data/datasources/premium_remote_data_source.dart';
import 'package:offgrid_nation_app/features/root/domain/repositories/premium_repository.dart';

class PremiumRepositoryImpl implements PremiumRepository {
  final PremiumRemoteDataSource remoteDataSource;

  PremiumRepositoryImpl(this.remoteDataSource);

  @override
  Future<String> createCheckoutSession() {
    return remoteDataSource.createCheckoutSession();
  }
}
