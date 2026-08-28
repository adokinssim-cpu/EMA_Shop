import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/repositories/favorites_repository_impl.dart';
import '../domain/repositories/favorites_repository.dart';

final favoritesRepositoryProvider = Provider<FavoritesRepository>((ref) {
  return FavoritesRepositoryImpl();
});

class FavoritesNotifier extends StateNotifier<Set<String>> {
  final FavoritesRepository repository;

  FavoritesNotifier(this.repository) : super({}) {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final favorites = await repository.getFavorites();

    state = favorites;
  }

  Future<void> toggleFavorite(String productId) async {
    final updatedFavorites = {...state};

    if (updatedFavorites.contains(productId)) {
      updatedFavorites.remove(productId);
    } else {
      updatedFavorites.add(productId);
    }

    state = updatedFavorites;

    await repository.saveFavorites(state);
  }

  bool isFavorite(String productId) {
    return state.contains(productId);
  }

  Future<void> removeFavorite(String productId) async {
    final updatedFavorites = {...state};

    updatedFavorites.remove(productId);

    state = updatedFavorites;

    await repository.saveFavorites(state);
  }

  Future<void> clearFavorites() async {
    state = {};

    await repository.saveFavorites(state);
  }
}

final favoritesProvider = StateNotifierProvider<FavoritesNotifier, Set<String>>(
  (ref) {
    final repository = ref.watch(favoritesRepositoryProvider);

    return FavoritesNotifier(repository);
  },
);
