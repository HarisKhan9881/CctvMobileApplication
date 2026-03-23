import 'package:cctv_app/core/network/api_client.dart';
import 'package:cctv_app/core/network/api_config.dart';
import 'package:cctv_app/core/network/models/active_post.dart';

class CasePostService {
  final ApiClient _client;

  CasePostService({ApiClient? client})
      : _client = client ?? ApiClient(baseUrl: ApiConfig.baseUrl);

  String _normalizeBearerToken(String accessToken) {
    final trimmedToken = accessToken.trim();
    if (trimmedToken.toLowerCase().startsWith('bearer ')) {
      return trimmedToken.substring(7).trim();
    }
    return trimmedToken;
  }

  Future<List<ActivePost>> getAllActivePosts({
    required String accessToken,
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    final json = await _client.get(
      '/api/v1/case_post/get_all_active_posts',
      headers: {
        'Authorization': 'Bearer $normalizedToken',
      },
    );

    final content = json['CONTENT'];
    if (content is! List) {
      return const [];
    }

    return content
        .whereType<Map<String, dynamic>>()
        .map(ActivePost.fromJson)
        .toList();
  }
}
