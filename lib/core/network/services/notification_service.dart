import 'package:cctv_app/core/network/api_client.dart';
import 'package:cctv_app/core/network/api_config.dart';
import 'package:cctv_app/core/network/models/app_notification_item.dart';

class NotificationService {
  final ApiClient _client;

  NotificationService({ApiClient? client})
      : _client = client ?? ApiClient(baseUrl: ApiConfig.baseUrl);

  String _normalizeBearerToken(String accessToken) {
    final trimmedToken = accessToken.trim();
    if (trimmedToken.toLowerCase().startsWith('bearer ')) {
      return trimmedToken.substring(7).trim();
    }
    return trimmedToken;
  }

  Future<List<AppNotificationItem>> getAppNotificationsByUserId({
    required int userId,
    required String accessToken,
    int limit = 50,
    int offset = 0,
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    final json = await _client.get(
      '/api/v1/notification/getAppNotificationByUserId?user_id=$userId&limit=$limit&offset=$offset',
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
        .map(AppNotificationItem.fromJson)
        .toList();
  }
}
