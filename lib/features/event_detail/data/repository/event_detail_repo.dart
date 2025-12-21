import 'dart:developer';

import 'package:excelapp2025/core/api/services/api_service.dart';
import 'package:excelapp2025/features/event_detail/data/models/event_detail_model.dart';

class EventDetailRepo {
  Future<EventDetailModel> fetchEventDetail(int eventId) async {
    try {
      final response = await ApiService.get(
        '/events/$eventId',
        baseUrl: ApiService.eventsTestingUrl,
      );

      if (response == null) {
        throw Exception('No data received from server');
      }

      if (response is! Map<String, dynamic>) {
        log('EventDetailRepo: Invalid response type: ${response.runtimeType}');
        throw Exception('Invalid response format: expected map');
      }

      return EventDetailModel.fromJson(response);
    } catch (e) {
      log('EventDetailRepo: Error fetching event detail: $e');
      rethrow;
    }
  }
}