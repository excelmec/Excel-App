abstract class DiscoverEvent {}

class LoadEventsEvent extends DiscoverEvent {}

class FilterEventsByCategoryEvent extends DiscoverEvent {
  final String category;
  final String type; // 'events' or 'competitions'

  FilterEventsByCategoryEvent({required this.category, required this.type});
}

class SearchEventsEvent extends DiscoverEvent {
  final String query;

  SearchEventsEvent({required this.query});
}
