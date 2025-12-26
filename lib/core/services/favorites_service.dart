import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesService {
  static const String _favoritesKey = 'favorite_events';
  static FavoritesService? _instance;

  FavoritesService._();

  static FavoritesService get instance {
    _instance ??= FavoritesService._();
    return _instance!;
  }

  /// Get all favorite event IDs
  Future<Set<int>> getFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = prefs.getString(_favoritesKey);

      if (favoritesJson == null || favoritesJson.isEmpty) {
        return {};
      }

      final List<dynamic> favoritesList = json.decode(favoritesJson);
      return favoritesList.map((e) => e as int).toSet();
    } catch (e) {
      return {};
    }
  }

  /// Add an event to favorites
  Future<bool> addFavorite(int eventId) async {
    try {
      final favorites = await getFavorites();
      favorites.add(eventId);
      return await _saveFavorites(favorites);
    } catch (e) {
      return false;
    }
  }

  /// Remove an event from favorites
  Future<bool> removeFavorite(int eventId) async {
    try {
      final favorites = await getFavorites();
      favorites.remove(eventId);
      return await _saveFavorites(favorites);
    } catch (e) {
      return false;
    }
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(int eventId) async {
    final favorites = await getFavorites();
    if (favorites.contains(eventId)) {
      return await removeFavorite(eventId);
    } else {
      return await addFavorite(eventId);
    }
  }

  /// Check if an event is favorited
  Future<bool> isFavorite(int eventId) async {
    final favorites = await getFavorites();
    return favorites.contains(eventId);
  }

  /// Clear all favorites
  Future<bool> clearFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return await prefs.remove(_favoritesKey);
    } catch (e) {
      return false;
    }
  }

  /// Save favorites to SharedPreferences
  Future<bool> _saveFavorites(Set<int> favorites) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final favoritesJson = json.encode(favorites.toList());
      return await prefs.setString(_favoritesKey, favoritesJson);
    } catch (e) {
      return false;
    }
  }
}
