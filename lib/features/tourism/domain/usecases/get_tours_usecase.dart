import '../../../../core/usecases/usecase.dart';
import '../entities/guide_entity.dart';
import '../entities/tour_entity.dart';
import '../repositories/tour_repository.dart';

class GetToursUseCase implements UseCase<List<TourEntity>, NoParams> {
  final TourRepository repository;

  GetToursUseCase(this.repository);

  @override
  Future<List<TourEntity>> call(NoParams params) {
    return repository.getTours();
  }
}

class GetGuidesUseCase implements UseCase<List<GuideEntity>, NoParams> {
  final TourRepository repository;

  GetGuidesUseCase(this.repository);

  @override
  Future<List<GuideEntity>> call(NoParams params) {
    return repository.getGuides();
  }
}
