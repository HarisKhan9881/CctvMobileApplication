import 'dart:convert';
import 'dart:io';

import 'package:cctv_app/core/network/api_config.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/models/uploaded_media.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ApplicationCloudService {
  const ApplicationCloudService();

  String _normalizeBearerToken(String accessToken) {
    final trimmedToken = accessToken.trim();
    if (trimmedToken.toLowerCase().startsWith('bearer ')) {
      return trimmedToken.substring(7).trim();
    }
    return trimmedToken;
  }

  Future<UploadedMedia> uploadImage({
    required String accessToken,
    required String filePath,
  }) {
    return _uploadFile(
      endpoint: '/api/v1/application_cloud/upload_image',
      accessToken: accessToken,
      filePath: filePath,
      fallbackMimeType: 'image/jpeg',
    );
  }

  Future<UploadedMedia> uploadVideo({
    required String accessToken,
    required String filePath,
  }) {
    return _uploadFile(
      endpoint: '/api/v1/application_cloud/upload_video',
      accessToken: accessToken,
      filePath: filePath,
      fallbackMimeType: 'video/mp4',
    );
  }

  Future<UploadedMedia> _uploadFile({
    required String endpoint,
    required String accessToken,
    required String filePath,
    required String fallbackMimeType,
  }) async {
    final normalizedToken = _normalizeBearerToken(accessToken);
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${ApiConfig.baseUrl}$endpoint'),
    );

    request.headers.addAll({
      'accept': 'application/json',
      'Authorization': 'Bearer $normalizedToken',
    });

    final mimeType = lookupMimeType(filePath) ?? fallbackMimeType;
    final mimeParts = mimeType.split('/');
    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        filePath,
        filename: File(filePath).uri.pathSegments.last,
        contentType: mimeParts.length == 2
            ? MediaType(mimeParts[0], mimeParts[1])
            : null,
      ),
    );

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

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
      final serverMessage = (json['MESSAGE'] as String?) ?? 'Upload failed';
      throw ApiException(
        '$serverMessage (${response.statusCode})',
        statusCode: response.statusCode,
      );
    }

    final content = json['CONTENT'];
    if (content is! Map<String, dynamic>) {
      throw ApiException('Upload response is missing content');
    }

    return UploadedMedia.fromJson(content);
  }
}
