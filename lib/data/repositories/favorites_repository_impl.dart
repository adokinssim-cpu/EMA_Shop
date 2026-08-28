import '../../domain/repositories/favorites_repository.dart';
import '../datasources/favorites_local_datasource.dart';

class FavoritesRepositoryImpl implements FavoritesRepository {
  final FavoritesLocalDataSource dataSource;

  FavoritesRepositoryImpl({FavoritesLocalDataSource? dataSource})
    : dataSource = dataSource ?? FavoritesLocalDataSource();

  @override
  Future<Set<String>> getFavorites() {
    return dataSource.getFavorites();
  }

  @override
  Future<void> saveFavorites(Set<String> favorites) {
    return dataSource.saveFavorites(favorites);
  }
}
