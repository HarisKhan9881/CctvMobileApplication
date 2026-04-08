import 'dart:convert';

import 'package:cctv_app/core/network/api_config.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/network_response_handler.dart';
import 'package:cctv_app/core/network/models/user_profile.dart';
import 'package:cctv_app/core/network/models/user_role.dart';
import 'package:cctv_app/core/network/models/user_option.dart';
import 'package:cctv_app/core/session/app_session_manager.dart';
import 'package:http/http.dart' as http;

class UserService {
  const UserService();

  Future<Map<String, dynamic>> createUser({
    required String accessToken,
    required String firstName,
    required String lastName,
    required String email,
    required String password,
    required int roleId,
    required int createdBy,
    int countryId = 0,
    int stateId = 0,
    int cityId = 0,
    String? dob,
    int genderId = 0,
    int profileTypeId = 0,
    int metaId = 0,
  }) async {
    final normalizedToken = await AppSessionManager.instance
        .requireValidAccessToken(accessToken);
    final url = Uri.parse('${ApiConfig.baseUrl}/api/v1/user/createUser');
    final response = await http.post(
      url,
      headers: {
        'accept': 'application/json',
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $normalizedToken',
      },
      body: jsonEncode({
        'first_name': firstName,
        'last_name': lastName,
        'user_email': email,
        'user_password': password,
        'country_id': countryId,
        'state_id': stateId,
        'city_id': cityId,
        'dob': dob ?? '',
        'gender_id': genderId,
        'profile_type_id': profileTypeId,
        'meta_id': metaId,
        'role_id': roleId,
        'created_by': createdBy,
      }),
    );

    return NetworkResponseHandler.parseJsonResponse(response);
  }

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

  Future<List<UserProfile>> getAllRecentAdmins({
    required String accessToken,
    int skip = 0,
    int limit = 4,
  }) async {
    final normalizedToken = await AppSessionManager.instance
        .requireValidAccessToken(accessToken);
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/api/v1/user/getAllRecentAdmins'
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

  Future<List<UserProfile>> getAllAdminsWithProfiles({
    required String accessToken,
    int skip = 0,
    int limit = 100,
  }) async {
    final normalizedToken = await AppSessionManager.instance
        .requireValidAccessToken(accessToken);
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/api/v1/user/getAllAdminsWithProfiles'
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

  Future<List<UserRole>> getRoles({
    required String accessToken,
    bool onlyActive = true,
  }) async {
    final normalizedToken = await AppSessionManager.instance
        .requireValidAccessToken(accessToken);
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/api/v1/user/getRoles?only_active=$onlyActive',
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
        .map(UserRole.fromJson)
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

  Future<void> deleteUser({
    required String accessToken,
    required int userId,
  }) async {
    final normalizedToken = await AppSessionManager.instance
        .requireValidAccessToken(accessToken);
    final url = Uri.parse('${ApiConfig.baseUrl}/api/v1/user/deleteUser/$userId');
    final response = await http.delete(
      url,
      headers: {
        'accept': 'application/json',
        'Authorization': 'Bearer $normalizedToken',
      },
    );

    await NetworkResponseHandler.parseJsonResponse(response);
  }
}
