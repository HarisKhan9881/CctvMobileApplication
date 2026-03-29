import 'package:cctv_app/core/network/api_config.dart';
import 'package:cctv_app/core/network/network_response_handler.dart';
import 'package:cctv_app/core/network/models/country_option.dart';
import 'package:cctv_app/core/session/app_session_manager.dart';
import 'package:http/http.dart' as http;

class CommonParameterService {
  const CommonParameterService();

  Future<List<CountryOption>> getCountries({
    String? accessToken,
  }) async {
    final normalizedToken = accessToken == null || accessToken.trim().isEmpty
        ? null
        : await AppSessionManager.instance.requireValidAccessToken(accessToken);
    final url = Uri.parse('${ApiConfig.baseUrl}/api/v1/common_param/getCountry');
    final response = await http.get(
      url,
      headers: {
        'accept': 'application/json',
        if (normalizedToken != null) 'Authorization': 'Bearer $normalizedToken',
      },
    );

    final json = await NetworkResponseHandler.parseJsonResponse(response);

    final content = json['CONTENT'];
    if (content is! List) {
      return const [];
    }

    return content
        .whereType<Map<String, dynamic>>()
        .map(CountryOption.fromJson)
        .toList();
  }
}
