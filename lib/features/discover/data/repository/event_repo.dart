import 'dart:developer';

import 'package:excelapp2025/core/api/services/api_service.dart';
import 'package:excelapp2025/features/discover/data/models/event_model.dart';

class EventRepo {
  Future<List<EventModel>> fetchEvents() async {
    try {
      final response = await ApiService.get(
        '/events/',
        baseUrl: ApiService.eventsTestingUrl
      );
      final data = response as List<dynamic>;
      log(data.toString());
      return data.map((e) => EventModel.fromJson(e)).toList();
    } catch (e) {
      rethrow;
    }
  }
}