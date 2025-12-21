abstract class CalendarEvent {}

class LoadCalendarEventsEvent extends CalendarEvent {}

class SelectDateEvent extends CalendarEvent {
  final DateTime date;

  SelectDateEvent({required this.date});
}
