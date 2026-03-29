import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/usecases/usecase.dart';
import '../../domain/usecases/get_tours_usecase.dart';
import 'tourism_state.dart';

class TourismCubit extends Cubit<TourismState> {
  final GetToursUseCase getToursUseCase;
  final GetGuidesUseCase getGuidesUseCase;

  TourismCubit({
    required this.getToursUseCase,
    required this.getGuidesUseCase,
  }) : super(const TourismInitial());

  Future<void> loadTours() async {
    emit(const TourismLoading());
    try {
      final tours = await getToursUseCase(NoParams());
      final guides = await getGuidesUseCase(NoParams());
      emit(TourismLoaded(allTours: tours, allGuides: guides));
    } catch (e) {
      emit(TourismError(e.toString()));
    }
  }

  void search(String query) {
    final current = state;
    if (current is TourismLoaded) {
      emit(current.copyWith(searchQuery: query));
    }
  }

  void clearSearch() {
    final current = state;
    if (current is TourismLoaded) {
      emit(current.copyWith(searchQuery: ''));
    }
  }

  void filterByCategory(String? category) {
    final current = state;
    if (current is TourismLoaded) {
      // null = All; otherwise toggle (tap same category to clear)
      final newCategory = category == null
          ? null
          : current.selectedCategory == category ? null : category;
      emit(current.copyWith(selectedCategory: () => newCategory));
    }
  }
}
