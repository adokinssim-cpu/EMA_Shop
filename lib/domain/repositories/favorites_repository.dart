abstract class FavoritesRepository {
  Future<Set<String>> getFavorites();

  Future<void> saveFavorites(Set<String> favorites);
}
