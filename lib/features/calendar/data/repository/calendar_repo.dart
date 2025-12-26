import 'dart:developer';

import 'package:excelapp2025/core/api/services/api_service.dart';
import 'package:excelapp2025/features/calendar/data/models/calendar_event_model.dart';

class CalendarRepo {
  Future<List<CalendarEventModel>> fetchAllEvents() async {
    try {
      final response = await ApiService.get(
        '/schedule',
        baseUrl: ApiService.eventsTestingUrl,
      );

      final data = response as List<dynamic>;
      final allEvents = <CalendarEventModel>[];

      for (final dayData in data) {
        final events = dayData['events'] as List<dynamic>? ?? [];
        for (final eventJson in events) {
          try {
            allEvents.add(CalendarEventModel.fromJson(eventJson));
          } catch (e) {
            log('Error parsing event: $e');
          }
        }
      }

      return allEvents;
    } catch (e) {
      log('Error fetching schedule: $e');
      rethrow;
    }
  }
}
