import 'package:cctv_app/core/network/api_client.dart';
import 'package:cctv_app/core/network/api_config.dart';
import 'package:cctv_app/core/network/endpoints.dart';
import 'package:cctv_app/core/network/models/application_alert.dart';

class AdminControlService {
  final ApiClient _client;

  AdminControlService({ApiClient? client})
    : _client = client ?? ApiClient(baseUrl: ApiConfig.baseUrl);

  String _normalizeBearerToken(String accessToken) {
    final trimmedToken = accessToken.trim();
    if (trimmedToken.toLowerCase().startsWith('bearer ')) {
      return trimmedToken.substring(7).trim();
    }
    return trimmedToken;
  }

  Future<Map<String, dynamic>> createApplicationAlert({
    required String accessToken,
    required int createdBy,
    required String category,
    required String alertNote,
    int attachedMetaId = 0,
  }) {
    final normalizedToken = _normalizeBearerToken(accessToken);
    return _client.postJson(
      Endpoints.createApplicationAlert,
      headers: {'Authorization': 'Bearer $normalizedToken'},
      body: {
        'category': category,
        'alert_note': alertNote,
        'attached_meta_id': attachedMetaId,
        'created_by': createdBy,
      },
    );
  }

  Future<List<ApplicationAlert>> getAllApplicationAlerts({
    required String accessToken,
    bool onlyActive = true,
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    final json = await _client.get(
      '${Endpoints.getAllApplicationAlerts}?only_active=$onlyActive',
      headers: {'Authorization': 'Bearer $normalizedToken'},
    );

    final content = json['CONTENT'];
    if (content is! List) {
      return const [];
    }

    return content
        .whereType<Map<String, dynamic>>()
        .map(ApplicationAlert.fromJson)
        .toList();
  }
}
