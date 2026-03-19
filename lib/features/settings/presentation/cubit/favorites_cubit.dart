import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/toggle_favorite_usecase.dart';

// ── States ─────────────────────────────────────────────────────────────────
abstract class FavoritesState extends Equatable {
  const FavoritesState();

  @override
  List<Object?> get props => [];
}

class FavoritesInitial extends FavoritesState {
  const FavoritesInitial();
}

class FavoritesLoading extends FavoritesState {
  const FavoritesLoading();
}

class FavoritesLoaded extends FavoritesState {
  final Set<String> favoriteIds;

  const FavoritesLoaded(this.favoriteIds);

  @override
  List<Object?> get props => [favoriteIds];
}

class FavoritesError extends FavoritesState {
  final String message;

  const FavoritesError(this.message);

  @override
  List<Object?> get props => [message];
}

// ── Cubit ──────────────────────────────────────────────────────────────────
class FavoritesCubit extends Cubit<FavoritesState> {
  final WatchFavoritesUseCase watchFavoritesUseCase;
  final ToggleFavoriteUseCase toggleFavoriteUseCase;

  StreamSubscription<Set<String>>? _subscription;

  FavoritesCubit({
    required this.watchFavoritesUseCase,
    required this.toggleFavoriteUseCase,
  }) : super(const FavoritesInitial());

  void watchFavorites() {
    emit(const FavoritesLoading());
    _subscription = watchFavoritesUseCase().listen(
      (ids) => emit(FavoritesLoaded(ids)),
      onError: (e) => emit(FavoritesError(e.toString())),
    );
  }

  Future<void> toggleFavorite(String tourId, {required bool shouldFavorite}) async {
    try {
      await toggleFavoriteUseCase(
        ToggleFavoriteParams(tourId: tourId, shouldFavorite: shouldFavorite),
      );
    } catch (e) {
      emit(FavoritesError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
