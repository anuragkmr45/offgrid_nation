import 'package:offgrid_nation_app/core/constants/api_constants.dart';
import 'package:offgrid_nation_app/core/network/api_client.dart';
import 'package:offgrid_nation_app/core/session/auth_session.dart';
import 'package:offgrid_nation_app/core/errors/network_exception.dart';
import 'package:offgrid_nation_app/features/root/domain/entities/premium/premium_feed_response_model.dart';

abstract class PremiumRemoteDataSource {
  Future<String> createCheckoutSession();
  Future<PremiumFeedResponseModel> fetchPremiumFeed();
}

class PremiumRemoteDataSourceImpl implements PremiumRemoteDataSource {
  final ApiClient apiClient;
  final AuthSession authSession;

  PremiumRemoteDataSourceImpl({
    required this.apiClient,
    required this.authSession,
  });

  @override
  Future<String> createCheckoutSession() async {
    try {
      final token = await authSession.getSessionToken();
      if (token == null) throw const NetworkException('Not authorized');

      final res = await apiClient.post(
        ApiConstants.createCheckoutSessionEndpoint,
        headers: {'Authorization': 'Bearer $token'},
        body: {},
      );

      if (res == null || res['url'] == null) {
        throw const NetworkException('Invalid checkout session response');
      }

      return res['url'] as String;
    } catch (e) {
      throw NetworkException('Create checkout session failed: ${e.toString()}');
    }
  }

  @override
  Future<PremiumFeedResponseModel> fetchPremiumFeed() async {
    final token = await authSession.getSessionToken();
    if (token == null) throw const NetworkException('Not authorized');

    final res = await apiClient.get(
      ApiConstants.fetchPremiumFeedEndpoint,
      headers: {'Authorization': 'Bearer $token'},
    );
print("-------------res------------: $res");
    return PremiumFeedResponseModel.fromJson(res);
  }
}
