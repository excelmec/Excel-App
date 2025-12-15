import 'package:excelapp2025/features/discover/data/models/event_model.dart';

abstract class DiscoverState {}

class DiscoverInitial extends DiscoverState {}

class DiscoverLoading extends DiscoverState {}

class DiscoverLoaded extends DiscoverState {
  final List<EventModel> events;
  final List<EventModel> filteredEvents;

  DiscoverLoaded({required this.events, required this.filteredEvents});
}

class DiscoverError extends DiscoverState {
  final String message;

  DiscoverError({required this.message});
}
