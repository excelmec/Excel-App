import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:excelapp2025/features/discover/bloc/discover_event.dart';
import 'package:excelapp2025/features/discover/bloc/discover_state.dart';
import 'package:excelapp2025/features/discover/data/repository/event_repo.dart';
import 'package:excelapp2025/features/discover/data/models/event_model.dart';

class DiscoverBloc extends Bloc<DiscoverEvent, DiscoverState> {
  final EventRepo eventRepo;
  List<EventModel> _allEvents = [];

  DiscoverBloc({required this.eventRepo}) : super(DiscoverInitial()) {
    on<LoadEventsEvent>(_onLoadEvents);
    on<FilterEventsByCategoryEvent>(_onFilterEvents);
    on<SearchEventsEvent>(_onSearchEvents);
  }

  Future<void> _onLoadEvents(
    LoadEventsEvent event,
    Emitter<DiscoverState> emit,
  ) async {
    emit(DiscoverLoading());
    try {
      _allEvents = await eventRepo.fetchEvents();
      emit(DiscoverLoaded(events: _allEvents, filteredEvents: _allEvents));
    } catch (e) {
      emit(DiscoverError(message: e.toString()));
    }
  }

  void _onFilterEvents(
    FilterEventsByCategoryEvent event,
    Emitter<DiscoverState> emit,
  ) {
    if (state is DiscoverLoaded) {
      List<EventModel> filtered = _allEvents;

      // Filter by event type (events or competitions)
      filtered = filtered
          .where((e) => e.eventType.toLowerCase() == event.type.toLowerCase())
          .toList();

      // Filter by category if not "All"
      if (event.category.toLowerCase() != 'all') {
        filtered = filtered
            .where((e) =>
                e.category.toLowerCase() == event.category.toLowerCase())
            .toList();
      }

      emit(DiscoverLoaded(events: _allEvents, filteredEvents: filtered));
    }
  }

  void _onSearchEvents(
    SearchEventsEvent event,
    Emitter<DiscoverState> emit,
  ) {
    if (state is DiscoverLoaded) {
      final currentState = state as DiscoverLoaded;
      if (event.query.isEmpty) {
        emit(DiscoverLoaded(
            events: _allEvents, filteredEvents: _allEvents));
      } else {
        final filtered = currentState.events
            .where((e) =>
                e.name.toLowerCase().contains(event.query.toLowerCase()) ||
                e.about.toLowerCase().contains(event.query.toLowerCase()))
            .toList();
        emit(DiscoverLoaded(events: _allEvents, filteredEvents: filtered));
      }
    }
  }
}
