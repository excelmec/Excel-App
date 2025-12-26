abstract class FavoritesEvent {}

class LoadFavoritesEvent extends FavoritesEvent {}

class ToggleFavoriteEvent extends FavoritesEvent {
  final int eventId;

  ToggleFavoriteEvent(this.eventId);
}

class AddFavoriteEvent extends FavoritesEvent {
  final int eventId;

  AddFavoriteEvent(this.eventId);
}

class RemoveFavoriteEvent extends FavoritesEvent {
  final int eventId;

  RemoveFavoriteEvent(this.eventId);
}

class ClearFavoritesEvent extends FavoritesEvent {}
