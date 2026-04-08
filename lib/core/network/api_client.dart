import 'dart:convert';

import 'package:cctv_app/core/network/network_response_handler.dart';
import 'package:http/http.dart' as http;

class ApiClient {
  final String baseUrl;
  final http.Client _client;

  ApiClient({required this.baseUrl, http.Client? client})
    : _client = client ?? http.Client();

  Future<Map<String, dynamic>> get(
    String path, {
    Map<String, String>? headers,
    bool treatUnauthorizedAsSessionExpired = true,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _client.get(
      uri,
      headers: {'Accept': 'application/json', ...?headers},
    );

    return NetworkResponseHandler.parseJsonResponse(
      response,
      treatUnauthorizedAsSessionExpired: treatUnauthorizedAsSessionExpired,
    );
  }

  Future<Map<String, dynamic>> postJson(
    String path, {
    required Map<String, dynamic> body,
    Map<String, String>? headers,
    bool treatUnauthorizedAsSessionExpired = true,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        ...?headers,
      },
      body: jsonEncode(body),
    );

    return NetworkResponseHandler.parseJsonResponse(
      response,
      treatUnauthorizedAsSessionExpired: treatUnauthorizedAsSessionExpired,
    );
  }

  Future<Map<String, dynamic>> postForm(
    String path, {
    required Map<String, String> body,
    Map<String, String>? headers,
    bool treatUnauthorizedAsSessionExpired = true,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _client.post(
      uri,
      headers: {
        'Content-Type': 'application/x-www-form-urlencoded',
        'Accept': 'application/json',
        ...?headers,
      },
      body: body,
    );

    return NetworkResponseHandler.parseJsonResponse(
      response,
      treatUnauthorizedAsSessionExpired: treatUnauthorizedAsSessionExpired,
    );
  }

  Future<Map<String, dynamic>> delete(
    String path, {
    Map<String, String>? headers,
    bool treatUnauthorizedAsSessionExpired = true,
  }) async {
    final uri = Uri.parse('$baseUrl$path');
    final response = await _client.delete(
      uri,
      headers: {'Accept': 'application/json', ...?headers},
    );

    return NetworkResponseHandler.parseJsonResponse(
      response,
      treatUnauthorizedAsSessionExpired: treatUnauthorizedAsSessionExpired,
    );
  }
}
