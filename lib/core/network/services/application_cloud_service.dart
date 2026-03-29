import 'dart:typed_data';

import 'package:cctv_app/core/network/api_config.dart';
import 'package:cctv_app/core/network/api_exception.dart';
import 'package:cctv_app/core/network/network_response_handler.dart';
import 'package:cctv_app/core/network/models/uploaded_media.dart';
import 'package:cctv_app/core/session/app_session_manager.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

class ApplicationCloudService {
  const ApplicationCloudService();

  Future<UploadedMedia> uploadImage({
    required String accessToken,
    required String filePath,
    Uint8List? fileBytes,
    String? fileName,
  }) {
    return _uploadFile(
      endpoint: '/api/v1/application_cloud/upload_image',
      accessToken: accessToken,
      filePath: filePath,
      fallbackMimeType: 'image/jpeg',
      fileBytes: fileBytes,
      fileName: fileName,
    );
  }

  Future<UploadedMedia> uploadVideo({
    required String accessToken,
    required String filePath,
    Uint8List? fileBytes,
    String? fileName,
  }) {
    return _uploadFile(
      endpoint: '/api/v1/application_cloud/upload_video',
      accessToken: accessToken,
      filePath: filePath,
      fallbackMimeType: 'video/mp4',
      fileBytes: fileBytes,
      fileName: fileName,
    );
  }

  Future<UploadedMedia> _uploadFile({
    required String endpoint,
    required String accessToken,
    required String filePath,
    required String fallbackMimeType,
    Uint8List? fileBytes,
    String? fileName,
  }) async {
    final normalizedToken = await AppSessionManager.instance
        .requireValidAccessToken(accessToken);
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
    final contentType = mimeParts.length == 2
        ? MediaType(mimeParts[0], mimeParts[1])
        : null;
    final resolvedFileName =
        fileName ??
        filePath.split(RegExp(r'[\\/]')).where((part) => part.isNotEmpty).last;

    if (kIsWeb) {
      if (fileBytes == null) {
        throw const ApiException('File bytes are required for web uploads');
      }
      request.files.add(
        http.MultipartFile.fromBytes(
          'file',
          fileBytes,
          filename: resolvedFileName,
          contentType: contentType,
        ),
      );
    } else {
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          filePath,
          filename: resolvedFileName,
          contentType: contentType,
        ),
      );
    }

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);

    final json = await NetworkResponseHandler.parseJsonResponse(
      response,
      fallbackMessage: 'Upload failed',
    );

    final content = json['CONTENT'];
    if (content is! Map<String, dynamic>) {
      throw ApiException('Upload response is missing content');
    }

    return UploadedMedia.fromJson(content);
  }
}
