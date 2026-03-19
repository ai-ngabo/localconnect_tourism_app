import '../repositories/favorites_repository.dart';

class ToggleFavoriteParams {
  final String tourId;
  final bool shouldFavorite;

  const ToggleFavoriteParams({
    required this.tourId,
    required this.shouldFavorite,
  });
}

class ToggleFavoriteUseCase {
  final FavoritesRepository repository;

  ToggleFavoriteUseCase(this.repository);

  Future<void> call(ToggleFavoriteParams params) {
    return repository.toggleFavorite(
      params.tourId,
      shouldFavorite: params.shouldFavorite,
    );
  }
}

class WatchFavoritesUseCase {
  final FavoritesRepository repository;

  WatchFavoritesUseCase(this.repository);

  Stream<Set<String>> call() {
    return repository.favoritesStream();
  }
}
