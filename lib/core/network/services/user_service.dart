import 'dart:convert';

import 'package:cctv_app/core/network/api_config.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/network_response_handler.dart';
import 'package:cctv_app/core/network/models/user_profile.dart';
import 'package:cctv_app/core/network/models/user_option.dart';
import 'package:cctv_app/core/session/app_session_manager.dart';
import 'package:http/http.dart' as http;

class UserService {
  const UserService();

  Future<List<UserOption>> getAllUsers({
    required String accessToken,
  }) async {
    final normalizedToken = await AppSessionManager.instance
        .requireValidAccessToken(accessToken);
    final url = Uri.parse('${ApiConfig.baseUrl}/api/v1/user/getAllUsers');
    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $normalizedToken',
      },
    );

    final json = await NetworkResponseHandler.parseJsonResponse(response);

    final content = json['CONTENT'];
    if (content is! List) {
      return const [];
    }

    return content
        .whereType<Map<String, dynamic>>()
        .map(UserOption.fromJson)
        .toList();
  }

  Future<UserProfile> getUserById({
    required String accessToken,
    required int userId,
  }) async {
    final normalizedToken = await AppSessionManager.instance
        .requireValidAccessToken(accessToken);
    final url = Uri.parse('${ApiConfig.baseUrl}/api/v1/user/getUserById/$userId');
    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $normalizedToken',
      },
    );

    final json = await NetworkResponseHandler.parseJsonResponse(response);

    final content = json['CONTENT'];
    if (content is! Map<String, dynamic>) {
      throw const ApiException(
        'User response is missing content',
      );
    }

    return UserProfile.fromJson(content);
  }

  Future<List<UserProfile>> getAllRecentAdminsWithProfiles({
    required String accessToken,
    int skip = 0,
    int limit = 4,
  }) async {
    final normalizedToken = await AppSessionManager.instance
        .requireValidAccessToken(accessToken);
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/api/v1/user/getAllRecentAdminsWithProfiles'
      '?skip=$skip&limit=$limit',
    );
    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $normalizedToken',
      },
    );

    final json = await NetworkResponseHandler.parseJsonResponse(response);
    final content = json['CONTENT'];
    if (content is! List) {
      return const [];
    }

    return content
        .whereType<Map<String, dynamic>>()
        .map(UserProfile.fromJson)
        .toList();
  }

  Future<void> updateUser({
    required String accessToken,
    required int userId,
    required Map<String, dynamic> body,
  }) async {
    final normalizedToken = await AppSessionManager.instance
        .requireValidAccessToken(accessToken);
    final url = Uri.parse('${ApiConfig.baseUrl}/api/v1/user/updateUser/$userId');
    final response = await http.put(
      url,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $normalizedToken',
      },
      body: jsonEncode(body),
    );

    await NetworkResponseHandler.parseJsonResponse(response);
  }
}
