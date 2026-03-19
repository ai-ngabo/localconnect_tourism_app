abstract class FavoritesRepository {
  Stream<Set<String>> favoritesStream();
  Future<void> toggleFavorite(String tourId, {required bool shouldFavorite});
}
