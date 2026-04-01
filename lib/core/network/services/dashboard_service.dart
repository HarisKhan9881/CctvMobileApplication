import 'package:cctv_app/core/network/api_client.dart';
import 'package:cctv_app/core/network/api_config.dart';

class DashboardService {
  final ApiClient _client;

  DashboardService({ApiClient? client})
    : _client = client ?? ApiClient(baseUrl: ApiConfig.baseUrl);

  String _normalizeBearerToken(String accessToken) {
    final trimmedToken = accessToken.trim();
    if (trimmedToken.toLowerCase().startsWith('bearer ')) {
      return trimmedToken.substring(7).trim();
    }
    return trimmedToken;
  }

  Future<int> getLatestRegistrationCount({required String accessToken}) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    final json = await _client.get(
      '/api/v1/dashboard/getUserAnalysis',
      headers: {'Authorization': 'Bearer $normalizedToken'},
    );

    final content = json['CONTENT'];
    if (content is! List) {
      return 0;
    }

    DateTime? latestDate;
    int? latestCount;

    for (final item in content) {
      if (item is! Map<String, dynamic>) {
        continue;
      }

      final countValue = item['user_count'];
      if (countValue is! int) {
        continue;
      }

      final dateValue = item['registration_date'];
      final parsedDate = dateValue is String
          ? DateTime.tryParse(dateValue)
          : DateTime.tryParse(dateValue?.toString() ?? '');

      if (parsedDate == null) {
        latestCount ??= countValue;
        continue;
      }

      if (latestDate == null || parsedDate.isAfter(latestDate)) {
        latestDate = parsedDate;
        latestCount = countValue;
      }
    }

    return latestCount ?? 0;
  }

  Future<int> getActiveUserCount({required String accessToken}) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    final json = await _client.get(
      '/api/v1/dashboard/getActiveUser',
      headers: {'Authorization': 'Bearer $normalizedToken'},
    );

    final content = json['CONTENT'];
    if (content is Map<String, dynamic>) {
      final countValue = content['active_user_count'];
      if (countValue is int) {
        return countValue;
      }
    }

    return 0;
  }

  Future<List<DashboardUserAnalysisEntry>> getUserAnalysis({
    required String accessToken,
    DateTime? dateFrom,
    DateTime? dateTo,
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    final queryParameters = <String, String>{};
    if (dateFrom != null) {
      queryParameters['date_from'] = _formatDate(dateFrom);
    }
    if (dateTo != null) {
      queryParameters['date_to'] = _formatDate(dateTo);
    }

    final queryString = queryParameters.isEmpty
        ? ''
        : '?${Uri(queryParameters: queryParameters).query}';
    final json = await _client.get(
      '/api/v1/dashboard/getUserAnalysis$queryString',
      headers: {'Authorization': 'Bearer $normalizedToken'},
    );

    final content = json['CONTENT'];
    if (content is! List) {
      return const [];
    }

    final entries = <DashboardUserAnalysisEntry>[];
    for (final item in content) {
      if (item is! Map<String, dynamic>) {
        continue;
      }

      final dateValue = item['registration_date'];
      final parsedDate = dateValue is String
          ? DateTime.tryParse(dateValue)
          : DateTime.tryParse(dateValue?.toString() ?? '');
      final countValue = item['user_count'];

      if (parsedDate == null || countValue is! int) {
        continue;
      }

      entries.add(
        DashboardUserAnalysisEntry(date: parsedDate, count: countValue),
      );
    }

    entries.sort((a, b) => a.date.compareTo(b.date));
    return entries;
  }

  String _formatDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return normalized.toIso8601String().split('T').first;
  }
}

class DashboardUserAnalysisEntry {
  final DateTime date;
  final int count;

  const DashboardUserAnalysisEntry({required this.date, required this.count});
}
