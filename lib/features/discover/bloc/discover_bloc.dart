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
      emit(
        DiscoverError(
          message:
              'Failed to load events. Please check your connection and try again.',
        ),
      );
    }
  }

  void _onFilterEvents(
    FilterEventsByCategoryEvent event,
    Emitter<DiscoverState> emit,
  ) {
    if (state is DiscoverLoaded) {
      List<EventModel> filtered = _allEvents;

      if (event.type.toLowerCase() == 'events') {
        // Events tab logic
        if (event.category.toLowerCase() == 'all') {
          // Show everything except competitions
          filtered = filtered
              .where((e) => e.eventType.toLowerCase() != 'competition')
              .toList();
        } else if (event.category.toLowerCase() == 'workshops') {
          // Show only workshops
          filtered = filtered
              .where((e) => e.eventType.toLowerCase() == 'workshop')
              .toList();
        } else if (event.category.toLowerCase() == 'talks') {
          // Show only talks
          filtered = filtered
              .where((e) => e.eventType.toLowerCase() == 'talk')
              .toList();
        } else if (event.category.toLowerCase() == 'general') {
          // Show only general events
          filtered = filtered
              .where((e) => e.eventType.toLowerCase() == 'general')
              .toList();
        }
      } else if (event.type.toLowerCase() == 'competitions') {
        // Competitions tab logic
        if (event.category.toLowerCase() == 'all') {
          // Show all competitions
          filtered = filtered
              .where((e) => e.eventType.toLowerCase() == 'competition')
              .toList();
        } else if (event.category.toLowerCase() == 'cs-tech') {
          // Show competitions with cs_tech category
          filtered = filtered
              .where(
                (e) =>
                    e.eventType.toLowerCase() == 'competition' &&
                    e.category.toLowerCase() == 'cs_tech',
              )
              .toList();
        } else if (event.category.toLowerCase() == 'gen-tech') {
          // Show competitions with general_tech category
          filtered = filtered
              .where(
                (e) =>
                    e.eventType.toLowerCase() == 'competition' &&
                    e.category.toLowerCase() == 'general_tech',
              )
              .toList();
        } else if (event.category.toLowerCase() == 'non-tech') {
          // Show competitions with non_tech category
          filtered = filtered
              .where(
                (e) =>
                    e.eventType.toLowerCase() == 'competition' &&
                    e.category.toLowerCase() == 'non_tech',
              )
              .toList();
        }
      }

      emit(DiscoverLoaded(events: _allEvents, filteredEvents: filtered));
    }
  }

  void _onSearchEvents(SearchEventsEvent event, Emitter<DiscoverState> emit) {
    if (state is DiscoverLoaded) {
      final currentState = state as DiscoverLoaded;
      if (event.query.isEmpty) {
        emit(DiscoverLoaded(events: _allEvents, filteredEvents: _allEvents));
      } else {
        final filtered = currentState.events
            .where(
              (e) =>
                  e.name.toLowerCase().contains(event.query.toLowerCase()) ||
                  e.about.toLowerCase().contains(event.query.toLowerCase()),
            )
            .toList();
        emit(DiscoverLoaded(events: _allEvents, filteredEvents: filtered));
      }
    }
  }
}
