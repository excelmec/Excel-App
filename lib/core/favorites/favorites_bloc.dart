import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:excelapp2025/core/services/favorites_service.dart';
import 'favorites_event.dart';
import 'favorites_state.dart';

class FavoritesBloc extends Bloc<FavoritesEvent, FavoritesState> {
  final FavoritesService _favoritesService;

  FavoritesBloc({FavoritesService? favoritesService})
    : _favoritesService = favoritesService ?? FavoritesService.instance,
      super(FavoritesInitial()) {
    on<LoadFavoritesEvent>(_onLoadFavorites);
    on<ToggleFavoriteEvent>(_onToggleFavorite);
    on<AddFavoriteEvent>(_onAddFavorite);
    on<RemoveFavoriteEvent>(_onRemoveFavorite);
    on<ClearFavoritesEvent>(_onClearFavorites);
  }

  Future<void> _onLoadFavorites(
    LoadFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      emit(FavoritesLoading(state.favoriteIds));
      final favorites = await _favoritesService.getFavorites();
      emit(FavoritesLoaded(favorites));
    } catch (e) {
      emit(FavoritesError(state.favoriteIds, 'Failed to load favorites'));
    }
  }

  Future<void> _onToggleFavorite(
    ToggleFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final currentFavorites = Set<int>.from(state.favoriteIds);
      final isCurrentlyFavorite = currentFavorites.contains(event.eventId);

      if (isCurrentlyFavorite) {
        currentFavorites.remove(event.eventId);
      } else {
        currentFavorites.add(event.eventId);
      }

      emit(FavoritesLoaded(currentFavorites));

      // Persist in background
      await _favoritesService.toggleFavorite(event.eventId);
    } catch (e) {
      emit(FavoritesError(state.favoriteIds, 'Failed to update favorite'));
    }
  }

  Future<void> _onAddFavorite(
    AddFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final currentFavorites = Set<int>.from(state.favoriteIds);
      currentFavorites.add(event.eventId);

      emit(FavoritesLoaded(currentFavorites));

      // Persist in background
      await _favoritesService.addFavorite(event.eventId);
    } catch (e) {
      emit(FavoritesError(state.favoriteIds, 'Failed to add favorite'));
    }
  }

  Future<void> _onRemoveFavorite(
    RemoveFavoriteEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      final currentFavorites = Set<int>.from(state.favoriteIds);
      currentFavorites.remove(event.eventId);

      emit(FavoritesLoaded(currentFavorites));

      // Persist in background
      await _favoritesService.removeFavorite(event.eventId);
    } catch (e) {
      emit(FavoritesError(state.favoriteIds, 'Failed to remove favorite'));
    }
  }

  Future<void> _onClearFavorites(
    ClearFavoritesEvent event,
    Emitter<FavoritesState> emit,
  ) async {
    try {
      emit(FavoritesLoaded({}));
      await _favoritesService.clearFavorites();
    } catch (e) {
      emit(FavoritesError(state.favoriteIds, 'Failed to clear favorites'));
    }
  }
}
