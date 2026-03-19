import '../entities/guide_entity.dart';
import '../entities/tour_entity.dart';

abstract class TourRepository {
  Future<List<TourEntity>> getTours();
  Future<List<GuideEntity>> getGuides();
}
