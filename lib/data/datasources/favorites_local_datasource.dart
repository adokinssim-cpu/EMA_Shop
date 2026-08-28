import 'package:shared_preferences/shared_preferences.dart';

class FavoritesLocalDataSource {
  static const String _favoritesKey = 'favorite_products';

  Future<Set<String>> getFavorites() async {
    final preferences = await SharedPreferences.getInstance();

    final favorites = preferences.getStringList(_favoritesKey) ?? [];

    return favorites.toSet();
  }

  Future<void> saveFavorites(Set<String> favorites) async {
    final preferences = await SharedPreferences.getInstance();

    await preferences.setStringList(_favoritesKey, favorites.toList());
  }
}
