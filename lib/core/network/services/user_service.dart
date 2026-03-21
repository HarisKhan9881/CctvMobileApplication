import 'dart:convert';

import 'package:cctv_app/core/network/api_config.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/models/user_option.dart';
import 'package:http/http.dart' as http;

class UserService {
  const UserService();

  String _normalizeBearerToken(String accessToken) {
    final trimmedToken = accessToken.trim();
    if (trimmedToken.toLowerCase().startsWith('bearer ')) {
      return trimmedToken.substring(7).trim();
    }
    return trimmedToken;
  }

  Future<List<UserOption>> getAllUsers({
    required String accessToken,
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    final url = Uri.parse('${ApiConfig.baseUrl}/api/v1/user/getAllUsers');
    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
      },
    );

    Map<String, dynamic> json;
    try {
      json = jsonDecode(response.body) as Map<String, dynamic>;
    } catch (_) {
      throw ApiException(
        'Invalid server response',
        statusCode: response.statusCode,
      );
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final serverMessage = (json['MESSAGE'] as String?) ?? 'Request failed';
      throw ApiException(serverMessage, statusCode: response.statusCode);
    }

    final content = json['CONTENT'];
    if (content is! List) {
      return const [];
    }

    return content
        .whereType<Map<String, dynamic>>()
        .map(UserOption.fromJson)
        .toList();
  }
}
