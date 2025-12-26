import 'package:excelapp2025/core/api/services/api_service.dart';

class RegistrationRepo {
  Future<Map<String, dynamic>> registerForEvent({
    required int eventId,
    required String jwtToken,
    int teamId = 0,
    int ambassadorId = 0,
  }) async {
    final response = await ApiService.post(
      '/registration',
      headers: ApiService.authHeaders(jwtToken),
      baseUrl: ApiService.eventsTestingUrl,
      body: {
        'eventId': eventId,
        'teamId': teamId,
        'ambassadorId': ambassadorId,
      },
    );

    if (response == null) {
      return {'success': true, 'statusCode': 200, 'message': 'Registration successful'};
    }

    if (response is Map<String, dynamic>) {
      return {
        ...response,
        'success': true,
        'statusCode': 200,
      };
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

