import 'package:excelapp2025/core/api/services/api_service.dart';

class RegistrationRepo {
  Future<Map<String, dynamic>> registerForEvent({
    required int eventId,
    required String jwtToken,
    int? teamId,
    int ambassadorId = 0,
  }) async {
    final body = {'eventId': eventId, 'ambassadorId': ambassadorId};

    // Only include teamId if it's provided (for team events)
    if (teamId != null) {
      body['teamId'] = teamId;
    }

    final response = await ApiService.post(
      '/registration',
      headers: ApiService.authHeaders(jwtToken),
      baseUrl: ApiService.eventsTestingUrl,
      body: body,
    );

    if (response == null) {
      return {
        'success': false,
        'statusCode': 500,
        'message': 'Complete Profile to register',
      };
    }

    if (response is Map<String, dynamic>) {
      return {...response, 'success': true, 'statusCode': 200};
    }

    if (response is String) {
      return {
        'success': true,
        'statusCode': 200,
        'message': response,
        'data': response,
      };
    }

    return {
      'success': true,
      'statusCode': 200,
      'data': response,
      'message': 'Registration successful',
    };
  }
}
