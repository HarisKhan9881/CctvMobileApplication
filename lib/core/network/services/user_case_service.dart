import 'package:cctv_app/core/network/api_client.dart';
import 'package:cctv_app/core/network/api_config.dart';

class UserCaseService {
  final ApiClient _client;

  UserCaseService({ApiClient? client})
      : _client = client ?? ApiClient(baseUrl: ApiConfig.baseUrl);

  String _normalizeBearerToken(String accessToken) {
    final trimmedToken = accessToken.trim();
    if (trimmedToken.toLowerCase().startsWith('bearer ')) {
      return trimmedToken.substring(7).trim();
    }
    return trimmedToken;
  }

  Future<Map<String, dynamic>> createUserCase({
    required String accessToken,
    required Map<String, dynamic> body,
  }) {
    final normalizedToken = _normalizeBearerToken(accessToken);
    return _client.postJson(
      '/api/v1/user_case/createUserCase',
      body: body,
      headers: {
        'Authorization': 'Bearer $normalizedToken',
      },
    );
  }
}
