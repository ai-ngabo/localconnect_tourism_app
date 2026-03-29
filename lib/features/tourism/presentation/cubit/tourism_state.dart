import 'package:equatable/equatable.dart';

import '../../domain/entities/guide_entity.dart';
import '../../domain/entities/tour_entity.dart';

abstract class TourismState extends Equatable {
  const TourismState();

  @override
  List<Object?> get props => [];
}

class TourismInitial extends TourismState {
  const TourismInitial();
}

class TourismLoading extends TourismState {
  const TourismLoading();
}

class TourismLoaded extends TourismState {
  final List<TourEntity> allTours;
  final List<GuideEntity> allGuides;
  final String searchQuery;
  final String? selectedCategory;

  const TourismLoaded({
    required this.allTours,
    required this.allGuides,
    this.searchQuery = '',
    this.selectedCategory,
  });

  /// Tours filtered by search only (no category) — used on the Community tab.
  List<TourEntity> get searchFilteredTours {
    if (searchQuery.isEmpty) return allTours;
    return allTours
        .where(
            (t) => t.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  /// Tours filtered by both category and search — used on the Explore tab.
  List<TourEntity> get filteredTours {
    var tours = allTours;
    if (selectedCategory != null && selectedCategory!.isNotEmpty) {
      tours = tours
          .where((t) =>
              t.category.toLowerCase() == selectedCategory!.toLowerCase())
          .toList();
    }
    if (searchQuery.isNotEmpty) {
      tours = tours
          .where(
              (t) => t.title.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();
    }
    return tours;
  }

  List<GuideEntity> get filteredGuides {
    if (searchQuery.isEmpty) return allGuides;
    return allGuides
        .where((g) => g.name.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
  }

  TourismLoaded copyWith({
    List<TourEntity>? allTours,
    List<GuideEntity>? allGuides,
    String? searchQuery,
    String? Function()? selectedCategory,
  }) {
    return TourismLoaded(
      allTours: allTours ?? this.allTours,
      allGuides: allGuides ?? this.allGuides,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedCategory:
          selectedCategory != null ? selectedCategory() : this.selectedCategory,
    );
  }

  @override
  List<Object?> get props => [allTours, allGuides, searchQuery, selectedCategory];
}

class TourismError extends TourismState {
  final String message;

  const TourismError(this.message);

  @override
  List<Object?> get props => [message];
}
