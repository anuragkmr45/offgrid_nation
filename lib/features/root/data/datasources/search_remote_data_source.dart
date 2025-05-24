import 'package:offgrid_nation_app/core/constants/api_constants.dart';
import 'package:offgrid_nation_app/core/errors/network_exception.dart';
import 'package:offgrid_nation_app/core/network/api_client.dart';
import 'package:offgrid_nation_app/core/session/auth_session.dart';

abstract class SearchUserRemoteDataSource {
  /// Searches for users matching the given [query].
  /// Returns a list of user maps.
  Future<List<Map<String, dynamic>>> searchUsers(String query);
}

class SearchUserRemoteDataSourceImpl implements SearchUserRemoteDataSource {
  final ApiClient apiClient;
  final AuthSession authSession;

  SearchUserRemoteDataSourceImpl({
    required this.apiClient,
    required this.authSession,
  });

  @override
  Future<List<Map<String, dynamic>>> searchUsers(String query) async {
    try {
      final token = await authSession.getSessionToken();
      if (token == null) throw const NetworkException('Not authorized');
      // ✅ Correctly build URI using Uri.parse and replace
      final endpoint =
          Uri.parse(ApiConstants.baseUrl)
              .replace(
                path: ApiConstants.getSearchResultEndpoint,
                queryParameters: {'query': query},
              )
              .toString();
      print("-------endpoint---------------- $endpoint");

      final rawResponse = await apiClient.get(
        endpoint,
        headers: {'Authorization': 'Bearer $token'},
      );
      print("-------rawResponse---------------- $rawResponse");

      if (rawResponse == null) {
        throw const NetworkException('Empty response');
      }

      if (rawResponse is! Map<String, dynamic>) {
        throw const NetworkException('Invalid response format');
      }

      final usersJson = rawResponse['users'];
      if (usersJson == null || usersJson is! List) {
        throw const NetworkException('Malformed users data');
      }

      return usersJson.whereType<Map<String, dynamic>>().toList(
        growable: false,
      );
    } catch (e) {
      throw NetworkException('Failed to search users: $e');
    }
  }
}
