abstract class FavoritesState {
  final Set<int> favoriteIds;
  
  FavoritesState(this.favoriteIds);
  
  bool isFavorite(int eventId) => favoriteIds.contains(eventId);
}

class FavoritesInitial extends FavoritesState {
  FavoritesInitial() : super({});
}

class FavoritesLoading extends FavoritesState {
  FavoritesLoading(Set<int> favoriteIds) : super(favoriteIds);
}

class FavoritesLoaded extends FavoritesState {
  FavoritesLoaded(Set<int> favoriteIds) : super(favoriteIds);
}

class FavoritesError extends FavoritesState {
  final String message;
  
  FavoritesError(Set<int> favoriteIds, this.message) : super(favoriteIds);
}
