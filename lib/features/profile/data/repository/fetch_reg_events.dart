import 'package:excelapp2025/core/api/routes/api_routes.dart';
import 'package:excelapp2025/core/api/services/api_service.dart';
import 'package:excelapp2025/core/api/services/auth_service.dart';
import 'package:excelapp2025/features/discover/data/models/event_model.dart';

class FetchRegisteredEvents {
  static Future<List<EventModel>> returnRegisteredEvents() async {
    String token = await AuthService.getToken();
    final response = await ApiService.get(
      ApiRoutes.registeredEvents,
      headers: ApiService.authHeaders(token),
      baseUrl: ApiService.eventsTestingUrl,
    );
    if (response != null) {
      final data = response as List<dynamic>;

      final ndata = data.map((e) => EventModel.fromJson(e)).toList();
      // log(ndata[0].toString());
      return ndata;
    } else {
      return [];
    }
  }
}
