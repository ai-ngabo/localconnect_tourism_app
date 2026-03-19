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

  const TourismLoaded({
    required this.allTours,
    required this.allGuides,
    this.searchQuery = '',
  });

  List<TourEntity> get filteredTours {
    if (searchQuery.isEmpty) return allTours;
    return allTours
        .where((t) => t.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();
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
  }) {
    return TourismLoaded(
      allTours: allTours ?? this.allTours,
      allGuides: allGuides ?? this.allGuides,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [allTours, allGuides, searchQuery];
}

class TourismError extends TourismState {
  final String message;

  const TourismError(this.message);

  @override
  List<Object?> get props => [message];
}
