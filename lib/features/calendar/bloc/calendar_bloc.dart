import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:excelapp2025/features/calendar/bloc/calendar_event.dart';
import 'package:excelapp2025/features/calendar/bloc/calendar_state.dart';
import 'package:excelapp2025/features/calendar/data/repository/calendar_repo.dart';
import 'package:excelapp2025/features/calendar/data/models/calendar_event_model.dart';

class CalendarBloc extends Bloc<CalendarEvent, CalendarState> {
  final CalendarRepo calendarRepo;
  List<CalendarEventModel> _allEvents = [];

  CalendarBloc({required this.calendarRepo}) : super(CalendarInitial()) {
    on<LoadCalendarEventsEvent>(_onLoadCalendarEvents);
    on<SelectDateEvent>(_onSelectDate);
  }

  Future<void> _onLoadCalendarEvents(
    LoadCalendarEventsEvent event,
    Emitter<CalendarState> emit,
  ) async {
    emit(CalendarLoading());
    try {
      _allEvents = await calendarRepo.fetchAllEvents();
      final availableDates = _getAvailableDates();
      final initialDate = availableDates.isNotEmpty
          ? availableDates.first
          : DateTime.now();
      final events = _filterEventsByDate(initialDate);
      emit(CalendarLoaded(
        events: events,
        selectedDate: initialDate,
        availableDates: availableDates,
      ));
    } catch (e) {
      emit(CalendarError(message: e.toString()));
    }
  }

  void _onSelectDate(
    SelectDateEvent event,
    Emitter<CalendarState> emit,
  ) {
    if (state is CalendarLoaded) {
      final currentState = state as CalendarLoaded;
      final events = _filterEventsByDate(event.date);
      emit(CalendarLoaded(
        events: events,
        selectedDate: event.date,
        availableDates: currentState.availableDates,
      ));
    }
  }

  List<CalendarEventModel> _filterEventsByDate(DateTime date) {
    final selectedDateOnly = DateTime(date.year, date.month, date.day);
    final eventsForDate = _allEvents.where((event) {
      final eventDateOnly = DateTime(
        event.datetime.year,
        event.datetime.month,
        event.datetime.day,
      );
      return eventDateOnly.isAtSameMomentAs(selectedDateOnly);
    }).toList();

    eventsForDate.sort((a, b) => a.datetime.compareTo(b.datetime));
    return eventsForDate;
  }

  List<DateTime> _getAvailableDates() {
    final dates = _allEvents
        .map((e) => DateTime(
              e.datetime.year,
              e.datetime.month,
              e.datetime.day,
            ))
        .toSet()
        .toList();
    dates.sort();
    return dates;
  }
}
