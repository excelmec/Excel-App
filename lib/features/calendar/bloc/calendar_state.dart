import 'package:excelapp2025/features/calendar/data/models/calendar_event_model.dart';

abstract class CalendarState {}

class CalendarInitial extends CalendarState {}

class CalendarLoading extends CalendarState {}

class CalendarLoaded extends CalendarState {
  final List<CalendarEventModel> events;
  final DateTime selectedDate;
  final List<DateTime> availableDates;

  CalendarLoaded({
    required this.events,
    required this.selectedDate,
    required this.availableDates,
  });
}

class CalendarError extends CalendarState {
  final String message;

  CalendarError({required this.message});
}
