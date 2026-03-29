import 'dart:convert';

import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/session/app_session_manager.dart';
import 'package:http/http.dart' as http;

class NetworkResponseHandler {
  NetworkResponseHandler._();

  static Future<Map<String, dynamic>> parseJsonResponse(
    http.Response response, {
    String fallbackMessage = 'Request failed',
    bool treatUnauthorizedAsSessionExpired = true,
  }) async {
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
      final serverMessage = (json['MESSAGE'] as String?) ?? fallbackMessage;
      final normalizedMessage = serverMessage.trim().toLowerCase();
      final isUnauthorized =
          response.statusCode == 401 ||
          normalizedMessage.contains('jwt expired') ||
          normalizedMessage.contains('token expired') ||
          normalizedMessage.contains('unauthorized');

      if (treatUnauthorizedAsSessionExpired && isUnauthorized) {
        await AppSessionManager.instance.logout(isSessionExpired: true);
        throw const ApiException(
          'Session expired. Please log in again.',
          statusCode: 401,
        );
      }

      throw ApiException(serverMessage, statusCode: response.statusCode);
    }

    return json;
  }
}
