import 'package:cctv_app/core/network/api_config.dart';
import 'package:cctv_app/core/network/network_response_handler.dart';
import 'package:cctv_app/core/network/models/general_parameter_option.dart';
import 'package:cctv_app/core/session/app_session_manager.dart';
import 'package:http/http.dart' as http;

class GeneralParameterService {
  const GeneralParameterService();

  Future<List<GeneralParameterOption>> getByHeaderName({
    required String headerName,
    required String accessToken,
  }) async {
    final normalizedToken = await AppSessionManager.instance
        .requireValidAccessToken(accessToken);
    final encodedHeaderName = Uri.encodeQueryComponent(headerName);
    final url = Uri.parse(
      '${ApiConfig.baseUrl}/api/v1/common_param/getGeneralParameterByHeader?header_name=$encodedHeaderName',
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
        .map(GeneralParameterOption.fromJson)
        .toList();
  }
}
