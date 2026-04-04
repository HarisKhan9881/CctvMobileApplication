import 'package:cctv_app/core/network/api_client.dart';
import 'package:cctv_app/core/network/api_config.dart';
import 'package:cctv_app/core/network/endpoints.dart';
import 'package:cctv_app/core/network/models/active_reel.dart';
import 'package:cctv_app/core/network/models/pending_case.dart';

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
      Endpoints.createUserCase,
      body: body,
      headers: {'Authorization': 'Bearer $normalizedToken'},
    );
  }

  Future<Map<String, dynamic>> createUserReel({
    required String accessToken,
    required int reelMetaId,
    required String reelDescription,
  }) {
    final normalizedToken = _normalizeBearerToken(accessToken);
    return _client.postJson(
      Endpoints.createUserReel,
      body: {'reel_meta_id': reelMetaId, 'reel_description': reelDescription},
      headers: {'Authorization': 'Bearer $normalizedToken'},
    );
  }

  Future<List<ActiveReel>> getAllActiveReels({
    required String accessToken,
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    final json = await _client.get(
      Endpoints.getAllActiveReels,
      headers: {'Authorization': 'Bearer $normalizedToken'},
    );

    final content = json['CONTENT'];
    if (content is! List) {
      return const [];
    }

    return content
        .whereType<Map<String, dynamic>>()
        .map(ActiveReel.fromJson)
        .toList();
  }

  Future<ActiveReel?> getUserReel({
    required String accessToken,
    required int userId,
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    final json = await _client.get(
      '${Endpoints.getUserReel}?user_id=$userId',
      headers: {'Authorization': 'Bearer $normalizedToken'},
    );

    final content = json['CONTENT'];
    if (content is! Map<String, dynamic>) {
      return null;
    }

    return ActiveReel.fromJson(content);
  }

  Future<List<PendingCase>> getPendingCases({
    required String accessToken,
    required int userId,
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    final json = await _client.get(
      '${Endpoints.getPendingCasesByUserId}?user_id=$userId',
      headers: {'Authorization': 'Bearer $normalizedToken'},
    );

    final content = json['CONTENT'];
    if (content is! List) {
      return const [];
    }

    return content
        .whereType<Map<String, dynamic>>()
        .map(PendingCase.fromJson)
        .toList();
  }
}
